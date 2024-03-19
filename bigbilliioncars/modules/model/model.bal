import big_billion_cars.dbconnection;

import ballerina/io;
import ballerina/sql;
import ballerinax/postgresql.driver as _;

public type Appraisal record {|
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

|};

public isolated function addAppraisal(Appraisal appraisal) returns int|error {
    appraisal.is_active = true;
    appraisal.invntrySts = "created";
    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."Appraisal" (vin,"vehYear","vehMake", "vehModel","vehSeries","interiorColor","exteriorColor",user_id, is_active,"img1","invntrySts")
        VALUES (${appraisal.vin}, ${appraisal.vehYear},${appraisal.vehMake},${appraisal.vehModel},  
                ${appraisal.vehSeries}, ${appraisal.interiorColor},
                ${appraisal.exteriorColor},${appraisal.user_id}, 
                ${appraisal.is_active},${appraisal.img1},${appraisal.invntrySts})`);
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
	SET vin=${appraisal.vin}, "vehYear"=${appraisal.vehYear}, "vehModel"=${appraisal.vehModel}, "vehSeries"=${appraisal.vehSeries}, "vehMake"=${appraisal.vehMake}, "interiorColor"=${appraisal.interiorColor}, "exteriorColor"=${appraisal.exteriorColor}, img1=${appraisal.img1}
	WHERE appr_id=${appr_id}`);

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
        `SELECT * FROM big_billion_cars."Appraisal" WHERE appr_id = ${appr_id}`
    );
    return appr;
}

public isolated function downloadFile(string imageName) returns byte[]|error? {

    string imagePath = "D:/ballerina practice/ballerina images/" + imageName;
    byte[] bytes = check io:fileReadBytes(imagePath);
    return bytes;
}



