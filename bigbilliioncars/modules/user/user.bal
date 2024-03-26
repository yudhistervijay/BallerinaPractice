import ballerinax/postgresql.driver as _;
import ballerina/sql;
import big_billion_cars.dbconnection;

public type Users record {|
    string user_id?;
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

public  isolated function getUsers(string id) returns Users|error {
    Users users = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars.users WHERE "user_id" = ${id}`
    );
    return users;
}

public isolated function addUser(Users user) returns string|error {
    user.is_active = true;
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars.users (first_name, last_name,username,password, email, phone, is_active)
        VALUES (${user.first_name}, ${user.last_name},${user.username},${user.password},  
                ${user.email}, ${user.phone} , ${user.is_active})`);
    return "user added success";
} 

public isolated function findUser(string username, string password) returns string|Users|error{            
         Users result = check dbconnection:dbClient->queryRow(
            `SELECT * FROM big_billion_cars.users WHERE username = ${username} AND password = ${password}`
        ); 
        return result;              
}





