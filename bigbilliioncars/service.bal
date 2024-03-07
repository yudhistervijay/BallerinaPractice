import ballerina/http;

service /users on new http:Listener(8080) {
    
    isolated resource function get fetchUser(int id) returns Users|error? {
        return getUsers(id);
    }

    isolated resource function post addUser(@http:Payload Users user) returns int|error? {
        return addUser(user);
    }



}    