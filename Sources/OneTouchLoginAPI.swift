//
//  OneTouchLoginAPI.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public class OneTouchLoginAPI {
    
    public static let shared = OneTouchLoginAPI()
    
    public init() {}
    
    public func oneTouchLoginEmail(payload: [String: Any], redirectUrl: String?, oneTouchLoginEmailTemplate: String?, welcomeEmailTemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        
        let redirect_url = redirectUrl ?? ""
        let onetouchlogin_emailtemplate = oneTouchLoginEmailTemplate ?? ""
        let welcome_emailtemplate = welcomeEmailTemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "redirecturl": redirect_url,
            "noregistrationemailtemplate": onetouchlogin_emailtemplate,
            "welcomeemailtemplate": welcome_emailtemplate
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/onetouchlogin/email", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func oneTouchLoginPhone(payload: [String: Any], smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "smstemplate": sms_template
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/onetouchlogin/phone", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func oneTouchLoginPing(clientguid: String, completionHandler: @escaping LRAPIResponseHandler) {
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "clientguid": clientguid
        ]
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/smartlogin/ping", queryParams: queryParams, completionHandler: completionHandler)
    }
    
    public func oneTouchLoginVerification(otp: String, phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "otp": otp,
            "smstemplate": sms_template
        ]
        
        let body: [String: Any] = [
            "phone": phone
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/onetouchlogin/phone/verify", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func oneTouchEmailVerification(verificationtoken: String, welcomeemailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        
        let welcome_emailtemplate = welcomeemailtemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "verificationtoken": verificationtoken,
            "welcomeemailtemplate": welcome_emailtemplate
        ]
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/email/smartlogin", queryParams: queryParams, completionHandler: completionHandler)
    }
    
}
