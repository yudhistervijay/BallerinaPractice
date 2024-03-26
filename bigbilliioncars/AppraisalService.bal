import big_billion_cars.model;

import ballerina/http;
import ballerina/io;
import big_billion_cars.inventory;
import big_billion_cars.favoriteVehicle;
import ballerina/uuid;





listener http:Listener httpl = new (8080);



@http:ServiceConfig {cors: {allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200"], 
allowCredentials: false, 
allowHeaders: ["Content-Type","userId","AppraisalId","id"],
exposeHeaders: ["*"], 
maxAge: 84900}}

service /appraisal on httpl {
    resource function post addAppraiseVehicle(@http:Header string userId,model:Appraisal appraisal)returns model:Response|error? {
        return model:addAppraisal(userId,appraisal);
    }

    isolated resource function post updateAppraiseVehicle(@http:Header int id,model:Appraisal appraisal)returns model:Response|error {
        return model:editAppraisal(id, appraisal);
    }

    isolated resource function post deleteAppraisal(int apprRef)returns model:Response|error? {
        return model:deleteAppraisal(apprRef);
    }

    isolated resource function get downloadImage(string pic1) returns byte[]|error? {
        return model:downloadFile(pic1);

    }

    // isolated resource function post showToUi(@http:Header int AppraisalId) returns model:Appraisal|error? {
    //     return model:showAppraisal(AppraisalId);
    // }



     isolated resource function post showToUi(@http:Header int AppraisalId) returns model:showToUIRes|error? {
         model:Appraisal|error showAppraisal = model:showAppraisal(AppraisalId);
         model:showToUIRes  showToUicrd = {apr : check showAppraisal,message : "showToUi working" ,code : 200, status: true};
         return showToUicrd;
    }



    resource function post uploadImage(http:Request request) returns model:Response|error {
       string uuid4 = uuid:createType4AsString();
        stream<byte[], io:Error?> streamer = check request.getByteStream();
 
        // Writes the incoming stream to a file using the `io:fileWriteBlocksFromStream` API
        // by providing the file location to which the content should be written.

        check io:fileWriteBlocksFromStream("D:/ballerina practice/ballerina images/"+uuid4+".jpg", streamer);
        check streamer.close();
        model:Response resp = {message:uuid4+".jpg", code:200, status:true};
         return resp;
    }



    isolated resource function post apprList(@http:Header string userId,int pageNo,int pageSize) returns model:ApprCardsRes|error {
         model:Appraisal[]|error apprList = model:getApprList(userId,pageNo,pageSize);
         int|error? totlRcd = model:getTotalRecords("created",false,userId);
         int pages = model:getPages(check totlRcd ?: 0);
         model:ApprCardsRes  apprCards = {cards : check apprList, code : 200, message : "Appraisal cards success", status :true,totalRecords:check totlRcd ?: 0,totalPages:pages};
         return apprCards;
  
    }


    isolated resource function get filterAppraisal(string userId,string? make,string? model,int? year,int pageNumber, int pageSize) returns model:Appraisal[]|error? {
        return model:filterAppr(userId,make ?: "",model ?: "",year ?: 0,pageNumber,pageSize);
    }

    

    isolated resource function post moveToInventory(int apprRef) returns model:Response|error {
            return inventory:moveToInv(apprRef);
    }

    isolated resource function post moveToWishList(@http:Header string userId,int apprRef) returns model:Response|error {
        string|error favVeh = favoriteVehicle:addFavVeh(userId,apprRef );
        model:Response resp = {message:check favVeh, code:200, status:true};
         return resp;
    }

    isolated resource function post getFavoriteCards(@http:Header string userId,int pageNumber,int pageSize) returns favoriteVehicle:FavCardsRes|error {
         favoriteVehicle:FavCardsDto[]|error favVehList = favoriteVehicle:getFavVehList(userId, pageNumber,pageSize);
         int|error? totlRcd = favoriteVehicle:getFavRecords("created",false,userId);
         int pages = model:getPages(check totlRcd ?: 0);
         favoriteVehicle:FavCardsRes  favCards = {cards : check favVehList, code : 200, message : "favorite cards success", status :true,totalRecords:check totlRcd ?: 0,totalPages:pages};
         return favCards;
    }

    isolated resource function post removeFavorite(int apprId,@http:Header string userId) returns model:Response|error {
         string|error removeFavVeh = favoriteVehicle:removeFavVeh(apprId, userId);
         model:Response resp = {message:check removeFavVeh, code:200, status:true};
         return resp;
    }

    
}

