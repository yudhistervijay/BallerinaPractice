import ballerina/http;



@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type"],
exposeHeaders: ["*"], 
maxAge: 84900}}


service /dash on httpl{

    isolated resource function get getweatherinfo(decimal lati,decimal longi) returns json|error? {
        // Creates a new client with the Basic REST service URL.
    http:Client weatherClient = check new ("https://api.weatherapi.com");

    // Sends a `GET` request to the "/v1/current.json" resource.
    // The verb is not mandatory as it is default to "GET".
    http:Response response = check weatherClient->get("/v1/current.json?q="+lati.toString()+","+longi.toString()+"&key=933b063c2e53408290c63421241503");
    return response.getJsonPayload();
    }


 
   

}
