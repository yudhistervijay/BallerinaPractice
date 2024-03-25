import ballerina/http;
import ballerina/io;
import big_billion_cars.model ;


listener http:Listener httpl = new(8080);



@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200","http://10.175.1.65:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type","userId"],
exposeHeaders: ["*"], 
maxAge: 84900}}

service /appraisal on httpl {
    resource function post addAppraisal(int user_id,model:Appraisal appraisal)returns int|error? {
        return model:addAppraisal(user_id,appraisal);
    }

    isolated resource function post editAppraisal(int appr_id,model:Appraisal appraisal)returns string|error {
        return model:editAppraisal(appr_id, appraisal);
    }

    isolated resource function post deleteAppraisal(int apprRef)returns string|error? {
        return model:deleteAppraisal(apprRef);
    }

    isolated resource function get downloadImage(string pic1) returns byte[]|error? {
        return model:downloadFile(pic1);
    }

    isolated resource function get fetchAppraisal(int appr_id) returns model:Appraisal|error? {
        return model:showAppraisal(appr_id);
    }


    resource function post uploadImage(http:Request request) returns string|error {
        stream<byte[], io:Error?> streamer = check request.getByteStream();

        // Writes the incoming stream to a file using the `io:fileWriteBlocksFromStream` API
        // by providing the file location to which the content should be written.
        check io:fileWriteBlocksFromStream("./files/ReceivedFile.jpg", streamer);
        check streamer.close();
        return "File Received!";
    }


    isolated resource function post apprList(@http:Header int userId,int pageNo,int pageSize) returns model:Appraisal[]|error {
        return model:getApprList(userId,pageNo,pageSize);
    }


    isolated resource function get filterAppraisal(int userId,string? make,string? model,int? year,int pageNumber, int pageSize) returns model:Appraisal[]|error? {
        return model:filterAppr(userId,make ?: "",model ?: "",year ?: 0,pageNumber,pageSize);
    }

    


    
}

