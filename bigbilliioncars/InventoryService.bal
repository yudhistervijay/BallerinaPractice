import big_billion_cars.inventory;

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

service /inventory on httpl {
    isolated resource function post moveToInv(int appr_id) returns string|error {
        return inventory:moveToInv(appr_id);
    }
}