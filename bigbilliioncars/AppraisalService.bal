import big_billion_cars.model;

import ballerina/http;
import ballerina/io;
import ballerina/uuid;

listener http:Listener httpl = new (8080);



@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200"],
        allowCredentials: false,
        allowHeaders: ["Content-Type"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /appraisal on httpl {
    resource function post addAppraisal(string user_id, model:Appraisal appraisal) returns int|error? {
        return model:addAppraisal(user_id, appraisal);
    }

    isolated resource function post editAppraisal(int appr_id, model:Appraisal appraisal) returns string|error {
        return model:editAppraisal(appr_id, appraisal);
    }

    isolated resource function post deleteAppraisal(int appr_id) returns string|error? {
        return model:deleteAppraisal(appr_id);
    }

    isolated resource function get downloadImage(string imageName) returns byte[]|error? {
        return model:downloadFile(imageName);
    }

    isolated resource function get fetchAppraisal(int appr_id) returns model:Appraisal|error? {
        return model:showAppraisal(appr_id);
    }

    resource function post uploadImage(http:Request request) returns string|error {

        string uuid4 = uuid:createType4AsString();
        stream<byte[], io:Error?> streamer = check request.getByteStream();

        // Writes the incoming stream to a file using the `io:fileWriteBlocksFromStream` API
        // by providing the file location to which the content should be written.
        check io:fileWriteBlocksFromStream("./files/" + uuid4 + ".jpg", streamer);
        check streamer.close();
        return "File Received!";
    }

    isolated resource function get apprList(int user_id, int pageNumber, int pageSize) returns model:Appraisal[]|error {
        return model:getApprList(user_id, pageNumber, pageSize);
    }

}

