import ballerina/http;

@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type"],
 exposeHeaders: ["*"], 
 maxAge: 84900}}

service /users on new http:Listener(8080) {

    
    isolated resource function get fetchUser(int id) returns Users|error? {
        return getUsers(id);
    }

    isolated resource function post addUser(Users user)returns int|error? {
        return addUser(user);
    }

    isolated resource function get checkUser(string username, string password) returns string|Users|error {
        return findUser(username, password);
    }
    





}    