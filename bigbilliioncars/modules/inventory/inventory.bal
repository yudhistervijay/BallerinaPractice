import big_billion_cars.dbconnection;

import ballerina/sql;
import big_billion_cars.model;
import ballerina/time;



public type invntryCards record {
    model:Appraisal[] cards;
    int code;
    string message;
    boolean status;
    int totalRecords;
    int totalPages;
};

public type srchFtryCards record {
    model:AppraisalDto[] cards;
    int code;
    string message;
    boolean status;
    int totalRecords;
    int totalPages;
};


public isolated function moveToInv(int appr_id) returns model:Response|error {
    time:Utc currTime = time:utcNow();
    string invSts = "inventory";
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal"
	SET "invntrySts"=${invSts},"createdOn"=${currTime} WHERE id=${appr_id} AND "is_active"=true`);

    string invMsg="moved to inventory successfully";
    model:Response  response = {message : invMsg, code: 200, status : true};
    return response;
}

public isolated function getInvList(string user_id,int pageNumber,int pageSize) returns model:Appraisal[]|error {
   int offset = pageNumber * pageSize;
    model:Appraisal[] apprs = [];
    string invSts = "inventory";
    stream<model:Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE user_id = ${user_id} AND "invntrySts"=${invSts}
        AND "soldOut" =false AND "is_active"=true ORDER BY "createdOn" DESC LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from model:Appraisal appr in resultStream
        do {
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}


