import big_billion_cars.searchFactory;

import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200"],
        allowCredentials: false,
        allowHeaders: ["Content-Type"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /searchFactory on httpl {
    isolated resource function post buyCar(int appr_id, int buyerUser_id) returns string|error {
        return searchFactory:vehicleBuy(appr_id, buyerUser_id);
    }
}
