import ballerina/http;
// import ballerina/mime;
import ballerina/io;



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
    
    isolated resource function post addAppraisal(Appraisal appraisal)returns int|error? {
        return addAppraisal(appraisal);
    }

    isolated resource function post editAppraisal(int appr_id,Appraisal appraisal)returns string|error {
        return editAppraisal(appr_id, appraisal);
    }

    isolated resource function post deleteAppraisal(int appr_id)returns string|error? {
        return deleteAppraisal(appr_id);
    }

    isolated resource function post downloadImage(string imageName) returns byte[]|error? {
        return downloadFile(imageName);
    }

    isolated resource function get fetchAppraisal(int appr_id) returns Appraisal|error? {
        return showAppraisal(appr_id);
    }


    

    resource function post receiver(http:Request request) returns string|error {
        stream<byte[], io:Error?> streamer = check request.getByteStream();

        // Writes the incoming stream to a file using the `io:fileWriteBlocksFromStream` API
        // by providing the file location to which the content should be written.
        check io:fileWriteBlocksFromStream("./files/ReceivedFile.jpg", streamer);
        check streamer.close();
        return "File Received!";
    }

    



}    

