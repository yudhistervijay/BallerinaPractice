import big_billion_cars.dbconnection;

import ballerina/sql;
import ballerinax/postgresql.driver as _;

public type Users record {|
    string user_id?;
    string first_name;
    string last_name;
    string email;
    string phone;
    string username;
    string password?;
    boolean is_active?;
    string status?;
    string profilePicture?;
|};

public isolated function getUsers(string id) returns Users|error {

    Users users = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars.users WHERE user_id = ${id} AND is_active=true`
    );
    users.status="true";
    return users;
}

public type response record {
    boolean status;
};

public isolated function userPresent(string id) returns response|error {
    boolean isPresent;

    int count = check dbconnection:dbClient->queryRow(
        `SELECT COUNT(*) AS record_count FROM big_billion_cars.users WHERE "user_id" = ${id} AND is_active=true`
    );
    if (count == 1) {
        isPresent = true;
    } else {
        isPresent = false;
    }
    response res = {status: isPresent};
    return res;
}

public isolated function addUser(Users user) returns string|error {
    user.is_active = true;
    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars.users (user_id,first_name, last_name,username,password, email, phone, is_active)
        VALUES (${user.user_id.toString()},${user.first_name}, ${user.last_name},${user.username},${user.password},  
                ${user.email}, ${user.phone} , ${user.is_active})`);
    int|string? lastInsertId = result.lastInsertId;

    if lastInsertId is string {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

public isolated function findUser(string username, string password) returns string|Users|error {
    Users result = check dbconnection:dbClient->queryRow(
            `SELECT * FROM big_billion_cars.users WHERE username = ${username} AND password = ${password}`
        );
    return result;
}

public isolated function editUser(string user_id, Users user) returns response|error {
    // time:Utc currTime = time:utcNow();
   // user.is_active = true;
    // Users result = check dbconnection:dbClient->queryRow(
    //         `SELECT * FROM big_billion_cars.users WHERE "user_id" = ${user_id} AND is_active=true`
    //     );


    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."users"
	SET "first_name"=${user.first_name}, "last_name"=${user.last_name}, "email"=${user.email}, 
    "phone"=${user.phone},"user_id"=${user_id.toString()},"username"=${user.username},"profilePicture"=${user.profilePicture} ,"is_active"=true WHERE user_id=${user_id} AND is_active=true`);

    response res = {status: true};
    
    return  res;
}



