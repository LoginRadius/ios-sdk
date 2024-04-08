//
//  PasswordlessLoginAPI.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public class PasswordlessLoginAPI {
    
    public static let shared = PasswordlessLoginAPI()
    
    public init() {}
    
    public func passwordlessLoginWithEmail(email: String, passwordlesslogintemplate: String?, verificationurl: String, completionHandler: @escaping LRAPIResponseHandler) {
        let passwordlesslogin_template = passwordlesslogintemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/passwordlesslogin/email", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "email": email,
            "passwordlesslogintemplate": passwordlesslogin_template,
            "verificationurl": LoginRadiusSDK.sharedInstance.verificationUrl
        ], completionHandler: completionHandler)
    }
    
    public func passwordlessLoginWithUserName(username: String, passwordlesslogintemplate: String?, verificationurl: String, completionHandler: @escaping LRAPIResponseHandler) {
        let passwordlesslogin_template = passwordlesslogintemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/passwordlesslogin/email", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "username": username,
            "passwordlesslogintemplate": passwordlesslogin_template,
            "verificationurl": LoginRadiusSDK.sharedInstance.verificationUrl
        ], completionHandler: completionHandler)
    }
    
    public func passwordlessLoginVerificationWithVerificationToken(verificationtoken: String, welcomeemailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let welcomeemail_template = welcomeemailtemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/passwordlesslogin/email/verify", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "verificationtoken": verificationtoken,
            "welcomeemailtemplate": welcomeemail_template
        ], completionHandler: completionHandler)
    }
    
    public func passwordlessLoginSendOtpWithPhone(phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/passwordlesslogin/otp", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "phone": phone,
            "smstemplate": sms_template
        ], completionHandler: completionHandler)
    }
    
    public func passwordlessPhoneLoginWithPayload(payload: [String: Any], smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/login/passwordlesslogin/otp/verify", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "smstemplate": sms_template
        ], body: payload, completionHandler: completionHandler)
    }
    
}
