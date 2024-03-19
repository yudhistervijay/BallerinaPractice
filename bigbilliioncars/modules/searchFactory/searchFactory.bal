import ballerina/sql;
import big_billion_cars.dbconnection;
public isolated function vehicleBuy(int appr_id,int buyerUser_id) returns string|error {
    boolean soldStatus=true;
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal"
	SET soldOut=${soldStatus},buyerUser_id=${buyerUser_id} WHERE appr_id=${appr_id}`);

    return "car bought successfully";
}
