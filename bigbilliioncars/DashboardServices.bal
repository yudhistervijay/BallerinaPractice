import ballerina/http;


@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type"],
exposeHeaders: ["*"], 
maxAge: 84900}}


service /dash on httpl{


}
