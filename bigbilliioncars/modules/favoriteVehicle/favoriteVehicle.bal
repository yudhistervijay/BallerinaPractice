import big_billion_cars.dbconnection;

import ballerina/sql;

public type FavVeh record {|
    int favVeh_id?;
    int appr_id;
    int user_id;
    boolean isWishList;
|};

type Appraisal record {
    int appr_id?;
    string vin;
    int vehYear;
    string vehMake;
    string vehModel;
    string vehSeries;
    string interiorColor;
    string exteriorColor;
    int user_id;
    boolean is_active?;
    string img1;
    string invntrySts?;
    boolean soldOut;
    int buyerUser_id?;
};

public isolated function addFavVeh(int appr_id, int user_id) returns string|error {
    string invSts = "inventory";
    Appraisal wish = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE appr_id = ${appr_id} AND invntrySts=${invSts} AND
        is_active = true`
    );
    FavVeh wishListedCar = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars."FavVeh" WHERE appr_id = ${appr_id} AND user_id=${user_id}`
    );

    if (wishListedCar is () ) {
        boolean wishlist = true;
        sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."FavVeh" (appr_id,user_id,"isWishList")
        VALUES (${wish.appr_id}, ${wish.user_id},${wishlist})`);
    } else {
        sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."FavVeh" SET isWishList=true WHERE appr_id=${appr_id} AND user_id=${user_id}`);
    }

    return "vehicle has be add to favorite";
}

public isolated function removeFavVeh(int appr_id, int user_id) returns string|error {

    FavVeh wishListedCar = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars."FavVeh" WHERE appr_id = ${appr_id} AND user_id=${user_id}`
    );

    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."FavVeh" SET isWishList=false WHERE appr_id=${appr_id} AND user_id=${user_id}`);

    return "vehicle has be add to favorite";
}
