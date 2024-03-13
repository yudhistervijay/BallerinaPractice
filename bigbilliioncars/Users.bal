import ballerinax/postgresql.driver as _;
import ballerinax/postgresql;
import ballerina/sql;
// import ballerina/email;

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
        INSERT INTO big_billion_cars.users (first_name, last_name,username,password, email, phone, is_active)
        VALUES (${user.first_name}, ${user.last_name},${user.username},${user.password},  
                ${user.email}, ${user.phone} , ${user.is_active})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

isolated function findUser(string username, string password) returns string|Users|error{            
         Users result = check dbClient->queryRow(
            `SELECT * FROM big_billion_cars.users WHERE username = ${username} AND password = ${password}`
        ); 
        return result;              
}


// public function main() returns error? {
//     // Creates an SMTP client with the connection parameters, host, username, and password. 
//     // The default port number `465` is used over SSL with these configurations. `SmtpConfig` can 
//     // be configured and passed to this client if the port or security is to be customized.
//     email:SmtpClient smtpClient = check new ("smtp.email.com", "yudhistervijay@gmail.com" , "Massil@123");

//     // Defines the email that is required to be sent.
//     email:Message email = {
//         to: "rupeshkhade7387.com",
//         // Subject of the email is added as follows. This field is mandatory.
//         subject: "Sample Email",
//         // Body content (text) of the email is added as follows. This field is optional.
//         body: "This is a sample email."
//     };

//     // Sends the email message with the client. The `send` method can be used instead if the 
//     // email is required to be sent with mandatory and optional parameters instead of 
//     // configuring an `email:Message` record.
//     check smtpClient->sendMessage(email);
    
// }


