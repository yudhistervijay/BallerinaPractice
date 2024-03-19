import big_billion_cars.dbconnection;

import ballerina/sql;
import big_billion_cars.model;


public isolated function moveToInv(int appr_id) returns string|error {
    string invSts = "inventory";
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal"
	SET "invntrySts"=${invSts} WHERE appr_id=${appr_id} AND "is_active"=true`);

    return "Moved to inventory";
}

public isolated function getInvList(int user_id,int pageNumber,int pageSize) returns model:Appraisal[]|error {
    int pageNum;
    if(pageNumber<=0){
        pageNum=1;
    }else{
        pageNum=pageNumber;
    }
    int offset = (pageNum - 1) * pageSize; 
    model:Appraisal[] apprs = [];
    string invSts = "inventory";
    stream<model:Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE user_id = ${user_id} AND "invntrySts"=${invSts}
        AND "soldOut" =false AND "is_active"=true LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from model:Appraisal appr in resultStream
        do {
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}
