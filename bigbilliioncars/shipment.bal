import big_billion_cars.searchFactory;

import big_billion_cars.model;
import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200"],
        allowCredentials: false,
        allowHeaders: ["Content-Type","userId","id"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /shipment on httpl {    
    
    isolated resource function post getPurCarCards(@http:Header string id,int pageNo,int pageSize) returns model:ApprCardsRes|error {
        model:Appraisal[]|error purList = searchFactory:getMyPurList(id, pageNo,pageSize);
        int|error? totlRc = model:getRecordsForPurchase("inventory",true,id);
         int pages = model:getPages(check totlRc ?: 0);
         model:ApprCardsRes  apprCards = {cards : check purList, code : 200, message : "purchase cards success", status :true,totalRecords:check totlRc ?: 0,totalPages:pages};
         return apprCards;
    }
    isolated resource function post getSoldCarCards(@http:Header string id,int pageNo,int pageSize) returns model:ApprCardsRes|error {
        model:Appraisal[]|error soldList = searchFactory:getMySalesList(id, pageNo,pageSize);
        int|error? totlRcd = model:getRecordsForSold("inventory",true,id);
         int pages = model:getPages(check totlRcd ?: 0);
         model:ApprCardsRes  apprCards = {cards : check soldList, code : 200, message : "sold cards success", status :true,totalRecords:check totlRcd ?: 0,totalPages:pages};
         return apprCards;
    }

}