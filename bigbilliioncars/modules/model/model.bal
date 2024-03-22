import big_billion_cars.dbconnection;

import big_billion_cars.mailcon;
import big_billion_cars.user;
import ballerina/io;
import ballerina/sql;
import ballerinax/postgresql.driver as _;
import ballerina/time;
// import ballerina/persist;



public type Appraisal record {|
    int appr_id?;
    string vin;
    int vehYear;
    string vehMake;
    string vehModel;
    string vehSeries;
    string interiorColor;
    string exteriorColor;
    int user_id?;
    boolean is_active?;
    string img1;
    string img2?;
    string img3?;
    string img4?;
    string invntrySts?;
    boolean soldOut?;
    int buyerUser_id?;
    float carPrice;
    string createdBy?;
    time:Utc createdOn?;
    string engineType;
    int vehMiles;
    string transmission;

|};


type ApprFilter record {|
    string vehMake;
    string vehModel;
    int vehYear;
|};


// time:Time time1 = time:parse("2017-06-26T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");


public function addAppraisal(int userId,Appraisal appraisal) returns int|error {
    time:Utc currTime = time:utcNow();
    appraisal.is_active = true;
    appraisal.invntrySts = "created";
    appraisal.soldOut= false;
    user:Users users = check user:getUsers(userId);
    appraisal.createdBy = users.username;
    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."Appraisal" (vin,"vehYear","vehMake", "vehModel","vehSeries","interiorColor","exteriorColor",user_id, is_active,"img1","img2","img3","img4","invntrySts","soldOut","carPrice","createdBy","createdOn","engineType","vehMiles","transmission")
        VALUES (${appraisal.vin}, ${appraisal.vehYear},${appraisal.vehMake},${appraisal.vehModel},  
                ${appraisal.vehSeries}, ${appraisal.interiorColor},
                ${appraisal.exteriorColor},${userId}, 
                ${appraisal.is_active},${appraisal.img1},${appraisal.img2},${appraisal.img3},${appraisal.img4},
                ${appraisal.invntrySts},${appraisal.soldOut},${appraisal.carPrice},${appraisal.createdBy},${currTime},${appraisal.engineType},${appraisal.vehMiles},${appraisal.transmission})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        error? mailService = mailcon:mailService(userId,appraisal.vin);
        return lastInsertId;
    } else {
        return error("Unable to add the appraisal");
    }
}

public isolated function editAppraisal(int appr_id, Appraisal appraisal) returns string|error {
    time:Utc currTime = time:utcNow();
    appraisal.is_active = true;
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."Appraisal"
	SET vin=${appraisal.vin}, "vehYear"=${appraisal.vehYear}, "vehModel"=${appraisal.vehModel}, 
    "vehSeries"=${appraisal.vehSeries}, "vehMake"=${appraisal.vehMake}, 
    "interiorColor"=${appraisal.interiorColor}, "exteriorColor"=${appraisal.exteriorColor}, 
    img1=${appraisal.img1},img2=${appraisal.img2},img3=${appraisal.img3},img4=${appraisal.img4},
    "carPrice"=${appraisal.carPrice},"createdOn"=${currTime},"engineType"=${appraisal.engineType},"vehMiles"=${appraisal.vehMiles},"transmission"=${appraisal.transmission} WHERE appr_id=${appr_id} AND is_active=true`);

    return "updated successfully";
}

public isolated function deleteAppraisal(int id) returns string|error? {
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal" SET is_active = false WHERE appr_id= ${id}`
    );
    return "appraisal car deleted successfully";
}

public isolated function showAppraisal(int appr_id) returns Appraisal|error {
    Appraisal appr = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE appr_id = ${appr_id} AND is_active=true`
    );
    return appr;
}

public isolated function downloadFile(string imageName) returns byte[]|error? {

    string imagePath = "D:/ballerina practice/ballerina images/" + imageName;
    byte[] bytes = check io:fileReadBytes(imagePath);
    return bytes;
}

public isolated function getApprList(int user_id, int pageNumber, int pageSize) returns Appraisal[]|error {
    int pageNum;
    if (pageNumber <= 0) {
        pageNum = 1;
    } else {
        pageNum = pageNumber;
    }
    int offset = (pageNum - 1) * pageSize; // Calculate the offset
    Appraisal[] apprs = [];
    stream<Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE user_id = ${user_id} and "invntrySts"='created' AND is_active=true 
        ORDER BY "createdOn" DESC  LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from Appraisal appr in resultStream
        do {
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}



 public isolated function filterAppr(int userId,string vehMake,string model, int year, int pageNumber, int pageSize) returns Appraisal[]|error {
    int pageNum;
    if (pageNumber <= 0) {
        pageNum = 1;
    } else {
        pageNum = pageNumber;
    }
    string make = "%"+vehMake+"%";
    string carModel = "%"+model+"%";
    int offset = (pageNum - 1) * pageSize; // Calculate the offset
    Appraisal[] apprs = [];
    stream<Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE user_id = ${userId} AND "invntrySts"='created'
        AND is_active=true OR "vehYear" = ${year} OR  "vehMake" like ${make} OR "vehModel" like ${carModel}
        ORDER BY "createdOn" DESC LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from Appraisal appr in resultStream
        do { 
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}


// public isolated function apprFilterDropdown(ApprFilter apprFilter) returns ApprFilter{
//     stream<ApprFilter, persist:Error?> apprNames = ;
//     ApprFilter[] sorted = check from var e in apprNames
//                         order by e.vehMake ascending, e.vehModel descending
//                         select e;
//     foreach ApprFilter e in sorted {
//         io:println(e.vehMake, " ", e.vehModel);
//     }

// }
