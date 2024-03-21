import ballerina/http;
import big_billion_cars.configuration;



@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200"],
        allowCredentials: false,
        allowHeaders: ["Content-Type"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /configs on httpl {

    isolated resource function post addConfig(configuration:ConfigCode config)returns int|error? {
        return configuration:addConfigCode(config);
    }

     isolated resource function post extClrList()returns configuration:ConfigCode[]|error? {
        return configuration:getExtrClrList();
    }

     isolated resource function post intrClrList()returns configuration:ConfigCode[]|error? {
        return configuration:getIntrClrList();
    }

}