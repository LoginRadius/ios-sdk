//
//  PinAuthentication.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public class PinAuthentication {
    
    public static let shared = PinAuthentication()
    
    public init() {}
    
    public func loginWithPin(session_token: String, payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "session_token": session_token
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/login/pin", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func setPinWithPinAuthToken(pinAuthToken: String, pin: String, completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "pinauthtoken": pinAuthToken
        ]
        
        let body: [String: Any] = [
            "pin": pin
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/pin/set/pinauthtoken", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func forgotPinWithEmail(email: String, emailtemplate: String?, resetpinurl: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let email_template = emailtemplate ?? ""
        let reset_pinurl = resetpinurl ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "emailtemplate": email_template,
            "resetpinurl": reset_pinurl
        ]
        
        let body: [String: Any] = [
            "email": email
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/pin/forgot/email", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func forgotPinWithUserName(username: String, emailtemplate: String?, resetpinurl: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let email_template = emailtemplate ?? ""
        let reset_pinurl = resetpinurl ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "emailtemplate": email_template,
            "resetpinurl": reset_pinurl
        ]
        
        let body: [String: Any] = [
            "username": username
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/pin/forgot/username", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func forgotPinWithPhone(phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "smstemplate": sms_template
        ]
        
        let body: [String: Any] = [
            "phone": phone
        ]
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/pin/forgot/otp", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func invalidatePinSessionToken(session_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "session_token": session_token
        ]
        
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/session_token/invalidate", queryParams: queryParams, completionHandler: completionHandler)
    }
    
    public func resetPinWithEmailAndOtp(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/otp/email", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPinWithUserNameAndOtp(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/otp/username", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPinWithPhoneAndOtp(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/otp/phone", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPinWithResetToken(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/token", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPinWithSecurityAnswerAndEmail(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/securityanswer/email", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPinWithSecurityAnswerAndUserName(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/securityanswer/username", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPinWithSecurityAnswerAndPhone(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/reset/securityanswer/phone", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func changePinWithAccessToken(access_token: String, payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/pin/change", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
}
