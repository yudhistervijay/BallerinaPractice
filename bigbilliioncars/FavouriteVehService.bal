import big_billion_cars.favoriteVehicle;

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

service /favourite on httpl {
    isolated resource function post makeFav(int appr_id, int user_id) returns string|error {
        return favoriteVehicle:addFavVeh(appr_id, user_id);
    }

    isolated resource function post removeFav(int appr_id, int user_id) returns string|error {
        return favoriteVehicle:removeFavVeh(appr_id, user_id);
    }
}
