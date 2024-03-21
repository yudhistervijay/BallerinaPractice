import big_billion_cars.dbconnection;
import ballerina/sql;

public type ConfigCode record {|
    int config_id?;
    string configType;
    string configGroup;
    string longCode;
    boolean is_active?;
|};

public isolated function addConfigCode(ConfigCode config) returns int|error {
    config.is_active = true;
    sql:ExecutionResult result = check dbconnection:dbClient->execute(`
        INSERT INTO big_billion_cars."ConfigCode" ("configType", "configGroup", "longCode", is_active)
        VALUES (${config.configType},${config.configGroup},${config.longCode}, ${config.is_active})`);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {        
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
} 


public isolated function getExtrClrList() returns ConfigCode[]|error {
    
    ConfigCode[] configs = [];
    stream<ConfigCode, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."ConfigCode" where "configType" = 'Exterior_Color' And is_active=true;`
    );
    check from ConfigCode config in resultStream
        do {
            configs.push(config);
        };
    check resultStream.close();
    return configs;
}


public isolated function getIntrClrList() returns ConfigCode[]|error {
    
    ConfigCode[] configs = [];
    stream<ConfigCode, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."ConfigCode" where "configType" = 'Interior_Color' And is_active=true;`
    );
    check from ConfigCode config in resultStream
        do {
            configs.push(config);
        };
    check resultStream.close();
    return configs;
}