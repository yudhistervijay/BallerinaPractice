import ballerinax/postgresql.driver as _;
import ballerinax/postgresql;

public type Users record {|
    int user_id?;
    string first_name;
    string last_name;
    string email;
    string phone;
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

