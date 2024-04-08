//
//  SmartLoginAPI.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation



public class SmartLoginAPI {
    public static let shared = SmartLoginAPI()
    
    public init() {}
    
    public func smartLoginWithEmail(email: String, clientguid: String, smartloginemailtemplate: String?, welcomeemailtemplate: String?, redirecturl: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let smartlogin_emailtemplate = smartloginemailtemplate ?? ""
        let welcome_emailtemplate = welcomeemailtemplate ?? ""
        let redirect_url = redirecturl ?? ""
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/smartlogin", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "email": email,
            "clientguid": clientguid,
            "smartloginemailtemplate": smartlogin_emailtemplate,
            "welcomeemailtemplate": welcome_emailtemplate,
            "redirecturl": redirect_url
        ], completionHandler: completionHandler)
    }
    
    public func smartLoginWithUsername(username: String, clientguid: String, smartloginemailtemplate: String?, welcomeemailtemplate: String?, redirecturl: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let smartlogin_emailtemplate = smartloginemailtemplate ?? ""
        let welcome_emailtemplate = welcomeemailtemplate ?? ""
        let redirect_url = redirecturl ?? ""
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/smartlogin", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "username": username,
            "clientguid": clientguid,
            "smartloginemailtemplate": smartlogin_emailtemplate,
            "welcomeemailtemplate": welcome_emailtemplate,
            "redirecturl": redirect_url
        ], completionHandler: completionHandler)
    }
    
    public func smartLoginPingWithClientguid(clientguid: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/smartlogin/ping", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "clientguid": clientguid
        ], completionHandler: completionHandler)
    }
    
    public func smartAutoLoginWithVerificationToken(verificationtoken: String, welcomeemailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let welcome_emailtemplate = welcomeemailtemplate ?? ""
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/email/smartlogin", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "verificationtoken": verificationtoken,
            "welcomeemailtemplate": welcome_emailtemplate
        ], completionHandler: completionHandler)
    }
}
