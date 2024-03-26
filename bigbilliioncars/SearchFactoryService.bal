import big_billion_cars.searchFactory;

import big_billion_cars.model;
import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200","http://10.175.1.59:4200"],
        allowCredentials: false,
        allowHeaders: ["Content-Type","userId"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /searchFactory on httpl {
    isolated resource function post buyCar(int appr_id, string buyerUser_id) returns string|error {
        return searchFactory:vehicleBuy(appr_id, buyerUser_id);
    }
    
    isolated resource function post purList(string user_id,int pageNumber,int pageSize) returns model:Appraisal[]|error {
        return searchFactory:getMyPurList(user_id, pageNumber,pageSize);
    }
    isolated resource function post salesList(string user_id,int pageNumber,int pageSize) returns model:Appraisal[]|error {
        return searchFactory:getMySalesList(user_id, pageNumber,pageSize);
    }
}
