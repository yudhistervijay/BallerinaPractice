import ballerina/http;
import big_billion_cars.user;


//service /users on new http:Listener(8082) 

@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200","http://10.175.1.59:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type","userId"],
exposeHeaders: ["*"], 
maxAge: 84900}}




service /user on httpl{

     isolated resource function get fetchUser(string id) returns user:Users|error? {
        return user:getUsers(id);
    }

     isolated resource function post addUser(user:Users user)returns string|error? {
        return user:addUser(user);
    }

    isolated resource function get checkUser(string username, string password) returns string|user:Users|error {
        return user:findUser(username, password);
    }
    
}


