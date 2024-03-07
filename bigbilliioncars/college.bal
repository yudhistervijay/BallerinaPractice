import ballerinax/postgresql.driver as _;
import ballerinax/postgresql;
// import ballerina/sql;

public type college record {|
    int college_id?;
    string name;
    string address;
   
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final postgresql:Client dbClient = 
                               check new (host=HOST, username = USER, password=PASSWORD, port=PORT, database="postgres");


isolated function getUsers(int id) returns college|error {
    college users = check dbClient->queryRow(
        `SELECT * FROM public.college WHERE college_id = ${id}`
    );
    return users;
}

// isolated function addUser(Users user) returns int|error {
//     user.is_active = true;
//     sql:ExecutionResult result = check dbClient->execute(`
//         INSERT INTO big_billion_cars.users (first_name, last_name, email, phone, is_active)
//         VALUES (${user.first_name}, ${user.last_name},  
//                 ${user.email}, ${user.phone} , ${user.is_active})`);
//     int|string? lastInsertId = result.lastInsertId;
//     if lastInsertId is int {
//         return lastInsertId;
//     } else {
//         return error("Unable to obtain last insert ID");
//     }
// }

