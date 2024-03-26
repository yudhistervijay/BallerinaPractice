import big_billion_cars.dbconnection;

import ballerina/sql;
import ballerina/time;
// import big_billion_cars.model;

public type FavVeh record {|
    int favVeh_id?;
    int appr_id;
    string user_id;
    boolean isVehicleFav?;
    time:Utc createdOn?;
|};

public type FavCardsRes record {
    FavCardsDto[] cards;
    int code;
    string message;
    boolean status;
    int totalRecords;
    int totalPages;
};

public type FavCardsDto record {
    string vinNumber;
    int vehicleYear;
    string vehicleMake;
    string vehicleModel;
    string vehicleSeries;
    string? vehiclePic1;
    int vehicleMileage;
    boolean isVehicleFav?;
    string user_id;
};




public isolated function addFavVeh( string user_id,int appr_id) returns string|error {

    time:Utc currTime = time:utcNow();
    // string invSts = "inventory";
    // model:Appraisal wish = check dbconnection:dbClient->queryRow(
    //     `SELECT * FROM big_billion_cars."Appraisal" WHERE appr_id = ${appr_id} AND invntrySts=${invSts} AND
    //     is_active = true`
    // );
    // FavVeh? wishListedCar = check dbconnection:dbClient->queryRow(
    //     `SELECT * FROM big_billion_cars."FavVeh" WHERE appr_id = ${appr_id} AND user_id=${user_id}`
    // );

    // if (wishListedCar is ()) {
        boolean wishlist = true;
        sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."FavVeh" (appr_id,"user_id","isVehicleFav","createdOn")
        VALUES (${appr_id}, ${user_id},${wishlist},${currTime})`);
    // } else {
    //     sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
    //     UPDATE big_billion_cars."FavVeh" SET isWishList=true WHERE appr_id=${appr_id} AND user_id=${user_id}`);
    // }

    return "vehicle has been add to favorite";
}

public isolated function removeFavVeh(int appr_id, string user_id) returns string|error {

    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."FavVeh" SET "isVehicleFav"=false WHERE appr_id=${appr_id} AND "user_id"=${user_id}`);

    return "vehicle has been removed to favorite";
}


public isolated function getFavVehList(string user_id,int pageNumber,int pageSize) returns FavCardsDto[]|error {
    
    int offset =  pageNumber * pageSize;
    FavCardsDto[] fV = [];
    stream<FavCardsDto, error?> resultStream = dbconnection:dbClient->query(
        `SELECT a.id,a."vinNumber" ,a."vehicleModel" ,a."vehicleSeries" ,a."vehicleMake",a."vehicleYear" , a."vehiclePic1",a."vehicleMileage",fv."isVehicleFav",fv.user_id 
            FROM big_billion_cars."Appraisal" a
            JOIN big_billion_cars."FavVeh" fv ON a.id = fv.appr_id
            WHERE fv."isVehicleFav" = true and fv.user_id = '598d968b-a7ac-4d26-87a4-ed4659e2d472' LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from FavCardsDto favVeh in resultStream
        do {
            fV.push(favVeh);
        };
    check resultStream.close();
    return fV;
}


public isolated function getFavRecords(string invSts, boolean soldOut, string userId)returns int|error?{
    int totalRec = check dbconnection:dbClient->queryRow(
        `SELECT COUNT(*) FROM big_billion_cars."FavVeh" where "user_id"=${userId} and "isVehicleFav"=true`
    );
    return totalRec;
}