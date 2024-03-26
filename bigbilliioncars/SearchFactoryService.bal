import big_billion_cars.searchFactory;

import big_billion_cars.model;
import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200"],
        allowCredentials: false,
        allowHeaders: ["Content-Type","userId","buyerUser_id"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /searchFactory on httpl {
    isolated resource function post buyCar(int appr_id,@http:Header string buyerUser_id) returns model:Response|error {
        string|error buyMsg = searchFactory:vehicleBuy(appr_id, buyerUser_id);
        model:Response resp = {message:check buyMsg, code:200, status:true};
         return resp;
    }
    
}
