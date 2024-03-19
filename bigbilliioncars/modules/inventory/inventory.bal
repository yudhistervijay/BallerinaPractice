import big_billion_cars.dbconnection;

import ballerina/sql;

public isolated function moveToInv(int appr_id) returns string|error {
    string invSts = "inventory";
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal"
	SET invntrySts=${invSts} WHERE appr_id=${appr_id}`);

    return "Moved to inventory";
}

