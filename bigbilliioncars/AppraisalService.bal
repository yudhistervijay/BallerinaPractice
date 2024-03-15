import ballerina/http;
// import ballerina/mime;
import ballerina/io;
import big_billion_cars.model ;




@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type"],
exposeHeaders: ["*"], 
maxAge: 84900}}

service /appraisal on new http:Listener(8080) {

    
   
    
    isolated resource function post addAppraisal(model:Appraisal appraisal)returns int|error? {
        return model:addAppraisal(appraisal);
    }

    isolated resource function post editAppraisal(int appr_id,model:Appraisal appraisal)returns string|error {
        return model:editAppraisal(appr_id, appraisal);
    }

    isolated resource function post deleteAppraisal(int appr_id)returns string|error? {
        return model:deleteAppraisal(appr_id);
    }

    isolated resource function post downloadImage(string imageName) returns byte[]|error? {
        return model:downloadFile(imageName);
    }

    isolated resource function get fetchAppraisal(int appr_id) returns model:Appraisal|error? {
        return model:showAppraisal(appr_id);
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

