import big_billion_cars.dbconnection;

import big_billion_cars.mailcon;
import big_billion_cars.user;
// import ballerina/uuid;
import ballerina/io;
import ballerina/sql;
import ballerinax/postgresql.driver as _;
import ballerina/time;
// import ballerina/persist;



public type Appraisal record {|
    int id?;
    string clientFirstName?;
    string clientLastName?;
    string clientPhNum?;
    string vinNumber;
    int vehicleYear;
    string vehicleMake;
    string vehicleModel;
    string vehicleSeries;
    int vehicleInterior?;
    int vehicleExtColor?;
    string user_id?;
    boolean is_active?;
    string? vehiclePic1;
    string? vehiclePic2;
    string? vehiclePic3;
    string? vehiclePic4;
    string invntrySts?;
    boolean soldOut?;
    string buyerUser_id?;
    float appraisedValue;
    string createdBy?;
    time:Utc createdOn?;
    string engineType;
    int vehicleMileage;
    string transmissionType;

|};


// type ApprFilter record {|
//     string vehicleMake;
//     string vehicleModel;
//     int vehicleYear;
// |};

public type Response record {
    string message;
    int code;
    boolean status; 
};



public type showToUIRes record {
    Appraisal apr;
    string message;
    int code;
    boolean status; 
};


// time:Time time1 = time:parse("2017-06-26T09:46:22.444-0500", "yyyy-MM-dd'T'HH:mm:ss.SSSZ");


public function addAppraisal(string userId,Appraisal appraisal) returns Response|error {
    time:Utc currTime = time:utcNow();
    appraisal.is_active = true;
    appraisal.invntrySts = "created";
    appraisal.soldOut= false;
    user:Users users = check user:getUsers(userId);
    appraisal.createdBy = users.username;
    if(appraisal.vehiclePic1 == ()){
        appraisal.vehiclePic1 = null;
    }if(appraisal.vehiclePic2 == ()){
        appraisal.vehiclePic2 = null ;
    }
    if(appraisal.vehiclePic3 == ()){
        appraisal.vehiclePic3 = null;
    }
    if(appraisal.vehiclePic4 == ()){
        appraisal.vehiclePic4 = null;
    }

    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."Appraisal" ("vinNumber","vehicleYear","vehicleMake", "vehicleModel","vehicleSeries","vehicleInterior","vehicleExtColor","user_id", is_active,"vehiclePic1","vehiclePic2","vehiclePic3","vehiclePic4","invntrySts","soldOut","appraisedValue","createdBy","createdOn","engineType","vehicleMileage","transmissionType","clientFirstName","clientLastName","clientPhNum")
        VALUES (${appraisal.vinNumber}, ${appraisal.vehicleYear},${appraisal.vehicleMake},${appraisal.vehicleModel},  
                ${appraisal.vehicleSeries}, ${appraisal.vehicleInterior},
                ${appraisal.vehicleExtColor},${userId}, 
                ${appraisal.is_active},${appraisal.vehiclePic1},${appraisal.vehiclePic2},${appraisal.vehiclePic3},${appraisal.vehiclePic4},
                ${appraisal.invntrySts},${appraisal.soldOut},${appraisal.appraisedValue},${appraisal.createdBy},${currTime},${appraisal.engineType},${appraisal.vehicleMileage},${appraisal.transmissionType},${appraisal.clientFirstName},${appraisal.clientLastName},${appraisal.clientPhNum})`);
    int|string? lastInsertId = result.lastInsertId;

    if lastInsertId is int {
        error? mailService = mailcon:mailService(userId,appraisal.vinNumber);
        string addMsg="Car details added successfully";
        Response  response = {message : addMsg, code: 200, status : true};
        return response;
    } else {
        string addMsg="Error occured when adding";
        Response  response = {message : addMsg, code: 500, status : true};
        return response;
    }
}

public isolated function editAppraisal(int id, Appraisal appraisal) returns Response|error {
    time:Utc currTime = time:utcNow();
    appraisal.is_active = true;
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(`
        UPDATE big_billion_cars."Appraisal"
	SET "vinNumber"=${appraisal.vinNumber}, "vehicleYear"=${appraisal.vehicleYear}, "vehicleModel"=${appraisal.vehicleModel}, 
    "vehicleSeries"=${appraisal.vehicleSeries}, "vehicleMake"=${appraisal.vehicleMake}, 
    "vehicleInterior"=${appraisal.vehicleInterior}, "vehicleExtColor"=${appraisal.vehicleExtColor}, 
    "vehiclePic1"=${appraisal.vehiclePic1},"vehiclePic2"=${appraisal.vehiclePic2},"vehiclePic3"=${appraisal.vehiclePic3},"vehiclePic4"=${appraisal.vehiclePic4},
    "appraisedValue"=${appraisal.appraisedValue},"createdOn"=${currTime},"engineType"=${appraisal.engineType},"vehicleMileage"=${appraisal.vehicleMileage},"transmissionType"=${appraisal.transmissionType},
    "clientFirstName"=${appraisal.clientFirstName},"clientLastName"=${appraisal.clientLastName},"clientPhNum"=${appraisal.clientPhNum} WHERE id=${id} AND is_active=true`);

    string delMsg="Car details updated successfully";
    Response  response = {message : delMsg, code: 200, status : true};
    return response;
}

public isolated function deleteAppraisal(int id) returns Response|error? {
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal" SET is_active = false WHERE id= ${id}`
    );
    string delMsg="selected car deleted successfully";
    Response  response = {message : delMsg, code: 200, status : true};
    return response;
}


public isolated function showAppraisal(int id) returns Appraisal|error {
    Appraisal appr = check dbconnection:dbClient->queryRow(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE id = ${id} AND is_active=true`
    );
    return appr;
}

public isolated function downloadFile(string imageName) returns byte[]|error? {

    string imagePath = "D:/ballerina practice/ballerina images/" + imageName;
    byte[] bytes = check io:fileReadBytes(imagePath);
    return bytes;
}

public isolated function getApprList(string user_id, int pageNumber, int pageSize) returns Appraisal[]|error {
    int pageNum;
    if (pageNumber <= 0) {
        pageNum = 1;
    } else {
        pageNum = pageNumber;
    }
    int offset = (pageNum - 1) * pageSize; // Calculate the offset
    Appraisal[] apprs = [];
    stream<Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE "user_id" = ${user_id} and "invntrySts"='created' AND is_active=true 
        ORDER BY "createdOn" DESC  LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from Appraisal appr in resultStream
        do {
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}



 public isolated function filterAppr(string userId,string vehMake,string model, int year, int pageNumber, int pageSize) returns Appraisal[]|error {
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
        `SELECT * FROM big_billion_cars."Appraisal" WHERE "user_id" = ${userId} AND "invntrySts"='created'
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


public isolated function getTotalRecords(string invSts, boolean soldOut, string userId)returns int|error?{
    int totalRec = check dbconnection:dbClient->queryRow(
        `SELECT COUNT(*) FROM big_billion_cars."Appraisal" where "invntrySts"= ${invSts} and "soldOut" = ${soldOut} and "user_id"=${userId} and is_active = true`
    );
    return totalRec;
}

public isolated function getRecordsSrchFtry(string invSts, boolean soldOut, string userId)returns int|error?{
    int totalRec = check dbconnection:dbClient->queryRow(
        `SELECT COUNT(*) FROM big_billion_cars."Appraisal" where "invntrySts"= ${invSts} and "soldOut" = ${soldOut} and "user_id" <> ${userId} and is_active = true`
    );
    return totalRec;
}

public isolated function getPages(int totalRecords) returns int{
    int totalPges= totalRecords/8;
    if(totalRecords%8 ==0){
        return totalPges;
    }else{
        return totalPges+1;
    }
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
