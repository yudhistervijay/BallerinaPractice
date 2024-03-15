import ballerina/http;
import big_billion_cars.user;
// import big_billion_cars.mailcon;

@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type"],
exposeHeaders: ["*"], 
maxAge: 84900}}

service /users on new http:Listener(8082) {
     isolated resource function get fetchUser(int id) returns user:Users|error? {
        return user:getUsers(id);
    }

     resource function post addUser(user:Users user)returns int|error? {
        return user:addUser(user);
    }

    isolated resource function get checkUser(string username, string password) returns string|user:Users|error {
        return user:findUser(username, password);
    }
    
}


