import ballerinax/postgresql.driver as _;
import ballerinax/postgresql;
import ballerina/sql;

public type Users record {|
    int user_id?;
    string first_name;
    string last_name;
    string email;
    string phone;
    boolean is_active?;
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final postgresql:Client dbClient = 
                               check new (host=HOST, username = USER, password=PASSWORD, port=PORT, database="postgres");


isolated function getUsers(int id) returns Users|error {
    Users users = check dbClient->queryRow(
        `SELECT * FROM big_billion_cars.users WHERE user_id = ${id}`
    );
    return users;
}

isolated function addUser(Users user) returns int|error {
    user.is_active = true;
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO big_billion_cars.users (first_name, last_name, email, phone, is_active)
        VALUES (${user.first_name}, ${user.last_name},  
                ${user.email}, ${user.phone} , ${user.is_active})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

