import ballerina/http;
import big_billion_cars.user;
import ballerina/uuid;
import ballerina/io;
import big_billion_cars.model;




type fileName record {
    string fileName;
    int code;
    boolean status;
};
//service /users on new http:Listener(8082) 

@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200"], 
allowCredentials: false, 

allowHeaders: ["Content-Type","userId"],
exposeHeaders: ["*"], 
maxAge: 84900}}




service /user on httpl{

     isolated resource function get fetchUser(string id) returns user:Users|error? {
        return user:getUsers(id);
    }


     isolated resource function get userCount(string id) returns user:response|error {
        return user:userPresent(id);  
    }


     isolated resource function post addUser(user:Users user)returns string|error? {
        return user:addUser(user);
    }

    isolated resource function get checkUser(string username, string password) returns string|user:Users|error {
        return user:findUser(username, password);
    }

    isolated resource function post editUser(string id, user:Users user) returns user:response|error {
        return user:editUser(id, user);
    }
   resource function post uploadProPic(http:Request request) returns fileName|error {

        string uuid4 = uuid:createType4AsString();
        stream<byte[], io:Error?> streamer = check request.getByteStream();

        // Writes the incoming stream to a file using the `io:fileWriteBlocksFromStream` API
        // by providing the file location to which the content should be written.
        check io:fileWriteBlocksFromStream("./files/" + uuid4 + ".jpg", streamer);
        check streamer.close();
        fileName res = {fileName: uuid4+".jpg",code:200,status:true};
        // model:Response resp = {message:uuid4+".jpg", code:200, status:true};
         return res;
    }

     isolated resource function get downloadImage(string imageName) returns byte[]|error? {
        return model:downloadFile(imageName);

    }
    
}


