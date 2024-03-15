import ballerinax/postgresql.driver as _;
import ballerina/sql;
import big_billion_cars.dbconnection;
import big_billion_cars.mailcon;

public type Users record {|
    int user_id?;
    string first_name;
    string last_name;
    string email;
    string phone;
    string username;
    string password;
    boolean is_active?;
|};

// configurable string USER = ?;
// configurable string PASSWORD = ?;
// configurable string HOST = ?;
// configurable int PORT = ?;
// configurable string DATABASE = ?;

public  isolated function getUsers(int id) returns Users|error {
    Users users = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars.users WHERE user_id = ${id}`
    );
    return users;
}

public  function addUser(Users user) returns int|error {
    user.is_active = true;
    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars.users (first_name, last_name,username,password, email, phone, is_active)
        VALUES (${user.first_name}, ${user.last_name},${user.username},${user.password},  
                ${user.email}, ${user.phone} , ${user.is_active})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        error? mailService = mailcon:mailService();
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
} 

public isolated function findUser(string username, string password) returns string|Users|error{            
         Users result = check dbconnection:dbClient->queryRow(
            `SELECT * FROM big_billion_cars.users WHERE username = ${username} AND password = ${password}`
        ); 
        return result;              
}





