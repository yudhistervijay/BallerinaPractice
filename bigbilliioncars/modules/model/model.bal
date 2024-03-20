import big_billion_cars.dbconnection;

import ballerina/io;
import ballerina/sql;
import ballerinax/postgresql.driver as _;
import ballerina/time;


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
    // string createdBy;
    time:Utc createdOn?;
|};

Appraisal[] apprs = [];

// time:Time time1 = time:parse("2017-06-26T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");

public isolated function addAppraisal(Appraisal appraisal) returns int|error {
    time:Utc currTime = time:utcNow();
    appraisal.is_active = true;
    appraisal.invntrySts = "created";
    appraisal.soldOut = false;
    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."Appraisal" (vin,"vehYear","vehMake", "vehModel","vehSeries","interiorColor","exteriorColor",user_id, is_active,"img1","img2","img3","img4","invntrySts","soldOut","carPrice","createdOn")
        VALUES (${appraisal.vin}, ${appraisal.vehYear},${appraisal.vehMake},${appraisal.vehModel},  
                ${appraisal.vehSeries}, ${appraisal.interiorColor},
                ${appraisal.exteriorColor},${appraisal.user_id}, 
                ${appraisal.is_active},${appraisal.img1},${appraisal.img2},${appraisal.img3},${appraisal.img4},
                ${appraisal.invntrySts},${appraisal.soldOut},${appraisal.carPrice},
                ${currTime})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to add the appraisal");
    }
}

public isolated function editAppraisal(int appr_id, Appraisal appraisal) returns string|error {
    appraisal.is_active = true;
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."Appraisal"
	SET vin=${appraisal.vin}, "vehYear"=${appraisal.vehYear}, "vehModel"=${appraisal.vehModel}, 
    "vehSeries"=${appraisal.vehSeries}, "vehMake"=${appraisal.vehMake}, 
    "interiorColor"=${appraisal.interiorColor}, "exteriorColor"=${appraisal.exteriorColor}, 
    img1=${appraisal.img1},img2=${appraisal.img2},img3=${appraisal.img3},img4=${appraisal.img4},
    "carPrice"=${appraisal.carPrice} WHERE appr_id=${appr_id} AND is_active=true`);

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

// public isolated function time() returns time:Utc {

//     // time:Utc currTime = time:utcNow();
    
//     time:Utc utc = time:utcNow();
//     string date = time:utcToString(utc);
//     //  // Parse the UTC timestamp string to a Time object
//     // time:Utc utcTime = check time:parse(date, "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS'Z'");
    
//     // // Define the desired output format
//     // string desiredFormat = "yyyy-MM-dd HH:mm:ss"; // Example: "YYYY-MM-DD HH:MM:SS"
    
//     // // Format the Time object into the desired format
//     // string formattedDateTime = time:format(utcTime, desiredFormat);
    
//     return utc;
// }
