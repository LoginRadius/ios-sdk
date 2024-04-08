//
//  CustomObjectAPI.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

public class CustomObjectAPI {
    
    
    public static let customInstance = CustomObjectAPI()
    
    
    public init() {}
    
    public func createCustomObject(withObjectName objectname: String,
                                   accessToken: String,
                                   payload: [String: Any],
                                   completionHandler: @escaping LRAPIResponseHandler) {
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.apiKey(),
            "access_token": accessToken,
            "objectname": objectname
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/customobject",
                                             queryParams: queryParams,
                                             body: payload,
                                             completionHandler: completionHandler)
    }
    
    public func getCustomObject(withObjectName objectname: String,
                                accessToken: String,
                                completionHandler: @escaping LRAPIResponseHandler) {
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.apiKey(),
            "access_token": accessToken,
            "objectname": objectname
        ]
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/customobject",
                                            queryParams: queryParams,
                                            completionHandler: completionHandler)
    }
    
    public func getCustomObject(withObjectRecordId objectRecordId: String,
                                accessToken: String,
                                objectname: String,
                                completionHandler: @escaping LRAPIResponseHandler) {
        
        var url:String
            
               if(objectRecordId.isEmpty){
                  url = "identity/v2/auth/customobject/objectRecordId"
               }
               else{
                   url = "identity/v2/auth/customobject/\(objectRecordId)"
               }
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.apiKey(),
            "access_token": accessToken,
            "objectname": objectname
        ]
        
        LoginRadiusREST.apiInstance.sendGET(url:url,
                                            queryParams: queryParams,
                                            completionHandler: completionHandler)
    }
    
    public func updateCustomObject(withObjectName objectname: String,
                                   accessToken: String,
                                   objectRecordId: String,
                                   updatetype: String,
                                   payload: [String: Any],
                                   completionHandler: @escaping LRAPIResponseHandler) {
        
        let url = "identity/v2/auth/customobject/\(objectRecordId)"
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.apiKey(),
            "access_token": accessToken,
            "objectname": objectname,
            "updatetype": updatetype
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url:url,
                                            queryParams: queryParams,
                                            body: payload,
                                            completionHandler: completionHandler)
    }
    
    public func deleteCustomObject(withObjectRecordId objectRecordId: String,
                                   accessToken: String,
                                   objectname: String,
                                   completionHandler: @escaping LRAPIResponseHandler) {
        
        var url:String
            
               if(objectRecordId.isEmpty){
                  url = "identity/v2/auth/customobject/objectRecordId"
               }
               else{
                   url = "identity/v2/auth/customobject/\(objectRecordId)"
               }

        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.apiKey(),
            "access_token": accessToken,
            "objectname": objectname
        ]
        
        LoginRadiusREST.apiInstance.sendDELETE(url:url,
                                               queryParams: queryParams,
                                               body: [:],
                                               completionHandler: completionHandler)
    }
}

