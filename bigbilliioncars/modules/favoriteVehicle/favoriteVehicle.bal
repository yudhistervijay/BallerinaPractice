import big_billion_cars.dbconnection;

import ballerina/sql;
// import big_billion_cars.model;

public type FavVeh record {|
    int favVeh_id?;
    int appr_id;
    int user_id;
    boolean isWishList?;
|};


public isolated function addFavVeh(int appr_id, int user_id) returns string|error {
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
        INSERT INTO big_billion_cars."FavVeh" (appr_id,user_id,"isWishList")
        VALUES (${appr_id}, ${user_id},${wishlist})`);
    // } else {
    //     sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
    //     UPDATE big_billion_cars."FavVeh" SET isWishList=true WHERE appr_id=${appr_id} AND user_id=${user_id}`);
    // }

    return "vehicle has been add to favorite";
}

public isolated function removeFavVeh(int appr_id, int user_id) returns string|error {

    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."FavVeh" SET "isWishList"=false WHERE appr_id=${appr_id} AND user_id=${user_id}`);

    return "vehicle has been removed to favorite";
}

public isolated function getFavVehList(int user_id,int pageNumber,int pageSize) returns FavVeh[]|error {
    
    int pageNum;
    if(pageNumber<=0){
        pageNum=1;
    }else{
        pageNum=pageNumber;
    }
    int offset = (pageNum - 1) * pageSize;
    FavVeh[] fV = [];
    stream<FavVeh, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."FavVeh" WHERE user_id = ${user_id} AND "isWishList"=true LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from FavVeh favVeh in resultStream
        do {
            fV.push(favVeh);
        };
    check resultStream.close();
    return fV;
}
