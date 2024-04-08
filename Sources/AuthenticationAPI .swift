//
//  AuthenticationAPI.swift
//  LoginRadiusSwiftSDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//



import Foundation

public class AuthenticationAPI {
    
    public static let shared = AuthenticationAPI()
    
    public init() {}
    
    /* ******************************* Post Method  **********************************/
    
    public func addEmail(withAccessToken access_token: String, emailtemplate: String?, payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let email_template = emailtemplate ?? ""
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/email", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token,
            "verificationurl": LoginRadiusSDK.sharedInstance.verificationUrl,
            "emailtemplate": email_template
        ], body: payload, completionHandler: completionHandler)
    }
    
    public func forgotPassword(withEmail email: String, emailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        var key = ""
        if email.contains("@") {
            key = "email"
        } else {
            key = "username"
        }
        let email_template = emailtemplate ?? ""
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/password", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "resetpasswordurl": LoginRadiusSDK.sharedInstance.verificationUrl,
            "emailtemplate": email_template
        ], body: [
            key: email
        ], completionHandler: completionHandler)
    }
    public func userRegistration(withSott sott: String,
                                 payload: [String: Any],
                                 emailtemplate: String?,
                                 smstemplate: String?,
                                 preventVerificationEmail: Bool,
                                 completionHandler: @escaping LRAPIResponseHandler) {
        var modifiedSott = sott
        let email_template = emailtemplate ?? ""
        let sms_template = smstemplate ?? ""
        var preventVerificationEmailString = ""
        
        if modifiedSott.contains("%") {
            modifiedSott = modifiedSott.removingPercentEncoding ?? ""
        }
        
        if preventVerificationEmail {
            preventVerificationEmailString = "PreventVerificationEmail"
        }
        
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/register", queryParams: [
            "apikey": LoginRadiusSDK.apiKey(),
            "registrationsource": LoginRadiusSDK.registrationSource(),
            "sott": modifiedSott,
            "verificationurl": LoginRadiusSDK.verificationUrl(),
            "emailtemplate": email_template,
            "smstemplate": sms_template,
            "options": preventVerificationEmailString
        ], body: payload, completionHandler: completionHandler)
    }
    
    
    public func login(withPayload payload: [String: Any], loginurl: String?, emailtemplate: String?, smstemplate: String?, g_recaptcha_response: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let login_url = loginurl ?? ""
        let email_template = emailtemplate ?? ""
        let sms_template = smstemplate ?? ""
        let recaptcha_response = g_recaptcha_response ?? ""
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/login", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "verificationurl": LoginRadiusSDK.sharedInstance.verificationUrl,
            "loginurl": login_url,
            "emailtemplate": email_template,
            "smstemplate": sms_template,
            "g-recaptcha-response": recaptcha_response
        ], body: payload, completionHandler: completionHandler)
    }
    
    public func forgotPassword(withPhone phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/password/otp", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "smstemplate": sms_template
        ], body: [
            "phone": phone
        ], completionHandler: completionHandler)
    }
    
    public func resendOtp(withPhone phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/phone/otp", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "smstemplate": sms_template
        ], body: [
            "phone": phone
        ], completionHandler: completionHandler)
    }
    
    public func resendOtp(withAccessToken access_token: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/phone/otp", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token,
            "smstemplate": sms_template
        ], body: [:], completionHandler: completionHandler)
    }
    
    
    
    /* ******************************* Get Method  **********************************/
    
    public func checkEmailAvailability(_ email: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/email", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "email": email
        ], completionHandler: completionHandler)
    }
    
    public func checkUserNameAvailability(_ username: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/username", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "username": username
        ], completionHandler: completionHandler)
    }
    
    public func profiles(withAccessToken access_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/account", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ], completionHandler: completionHandler)
    }

    public func validateAccessToken(_ access_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/access_token/validate", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ], completionHandler: completionHandler)
    }
    
    public func verifyEmail(withVerificationToken verificationtoken: String, url: String?, welcomeemailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let _url = url ?? ""
        let welcome_emailtemplate = welcomeemailtemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/email", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "verificationtoken": verificationtoken,
            "url": _url,
            "welcomeemailtemplate": welcome_emailtemplate
        ], completionHandler: completionHandler)
    }
    
    public func deleteAccount(withDeleteToken deletetoken: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/account/delete", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "deletetoken": deletetoken
        ], completionHandler: completionHandler)
    }
    
    public func invalidateAccessToken(_ access_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/access_token/invalidate", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ], completionHandler: completionHandler)
    }
    
    public func getSecurityQuestions(withAccessToken access_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/securityquestion/accesstoken", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ], completionHandler: completionHandler)
    }
    
    public func getSecurityQuestions(withEmail email: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/securityquestion/email", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "email": email
        ], completionHandler: completionHandler)
    }
    
    public func getSecurityQuestions(withUserName username: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/securityquestion/username", queryParams: [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "username": username
        ], completionHandler: completionHandler)
    }
    
    public func getSecurityQuestions(withPhone phone: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/securityquestion/phone", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "phone": phone], completionHandler: completionHandler)
    }
    
    public func phoneLogin(withOtp otp: String, phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "phone": phone, "otp": otp, "smstemplate": sms_template], completionHandler: completionHandler)
    }
    
    public func phoneNumberAvailability(_ phone: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/phone", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "phone": phone], completionHandler: completionHandler)
    }
    
    public func sendOtp(withPhone phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/login/otp", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "phone": phone, "smstemplate": sms_template], completionHandler: completionHandler)
    }
    
    public func sendWelcomeEmail(withAccessToken access_token: String, welcomeemailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let welcomeemail_template = welcomeemailtemplate ?? ""
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/account/sendwelcomeemail", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "access_token": access_token, "welcomeemailtemplate": welcomeemail_template], completionHandler: completionHandler)
    }
    
    public func privacyPolicyAccept(withAccessToken access_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "identity/v2/auth/privacypolicy/accept", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "access_token": access_token], completionHandler: completionHandler)
    }
    
    /* ******************************* Put Method  **********************************/
    
    public func changePassword(withAccessToken access_token: String, oldpassword: String, newpassword: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/change", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "access_token": access_token], body: ["oldpassword": oldpassword, "newpassword": newpassword], completionHandler: completionHandler)
    }
    
    public func linkSocialIdentities(withAccessToken access_token: String, candidatetoken: String, completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendPOST(url: "identity/v2/auth/socialidentity", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "access_token": access_token], body: ["candidatetoken": candidatetoken], completionHandler: completionHandler)
    }
    
    public func resendEmailVerification(_ email: String, emailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let email_template = emailtemplate ?? ""
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/register", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey, "verificationurl": LoginRadiusSDK.sharedInstance.verificationUrl, "emailtemplate": email_template], body: ["email": email], completionHandler: completionHandler)
    }
    
    public  func resetPasswordByResetToken(_ payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/reset", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey], body: payload, completionHandler: completionHandler)
    }
    
    public func resetPasswordBySecurityAnswerAndEmail(_ payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/securityanswer", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey], body: payload, completionHandler: completionHandler)
    }
    public func resetPasswordBySecurityAnswerAndPhone(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/securityanswer", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPasswordBySecurityAnswerAndUserName(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/securityanswer", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func changeUserNameWithAccessToken(access_token: String, username: String, completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ]
        
        let body: [String: Any] = [
            "username": username
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/username", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func updateProfileWithAccessToken(access_token: String, emailtemplate: String?, smstemplate: String?, payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let email_template = emailtemplate ?? ""
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token,
            "verificationurl": LoginRadiusSDK.sharedInstance.verificationUrl,
            "emailtemplate": email_template,
            "smstemplate": sms_template
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/account", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func updateSecurityQuestionWithAccessToken(access_token: String, payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/account", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func phoneNumberUpdateWithAccessToken(access_token: String, phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token,
            "smstemplate": sms_template
        ]
        
        let body: [String: Any] = [
            "phone": phone
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/phone", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func phoneResetPasswordByOtpWithPayload(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/otp", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func phoneVerificationWithOtp(otp: String, phone: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "otp": otp,
            "smstemplate": sms_template
        ]
        
        let body: [String: Any] = [
            "phone": phone
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/phone/otp", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func phoneVerificationOtpWithAccessToken(access_token: String, otp: String, smstemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let sms_template = smstemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token,
            "otp": otp,
            "smstemplate": sms_template
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/phone/otp", queryParams: queryParams, body: [:], completionHandler: completionHandler)
    }
    
    public func verifyEmailByOtpWithPayload(payload: [String: Any], url: String?, welcomeemailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let _url = url ?? ""
        let welcome_emailtemplate = welcomeemailtemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "url": _url,
            "welcomeemailtemplate": welcome_emailtemplate
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/email", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func resetPasswordByOtpWithPayload(payload: [String: Any], completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey
        ]
        
        LoginRadiusREST.apiInstance.sendPUT(url: "identity/v2/auth/password/reset", queryParams: queryParams, body: payload, completionHandler: completionHandler)
    }
    
    public func deleteAccountWithEmailConfirmation(access_token: String, emailtemplate: String?, completionHandler: @escaping LRAPIResponseHandler) {
        let email_template = emailtemplate ?? ""
        
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token,
            "deleteurl": LoginRadiusSDK.sharedInstance.verificationUrl,
            "emailtemplate": email_template
        ]
        
        LoginRadiusREST.apiInstance.sendDELETE(url: "identity/v2/auth/account", queryParams: queryParams, body: [:], completionHandler: completionHandler)
    }
    
    public func removeEmailWithAccessToken(access_token: String, email: String, completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ]
        
        let body: [String: Any] = [
            "email": email
        ]
        
        LoginRadiusREST.apiInstance.sendDELETE(url: "identity/v2/auth/email", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
    public func removePhoneIDWithAccessToken(access_token: String, completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ]
        
        LoginRadiusREST.apiInstance.sendDELETE(url: "identity/v2/auth/phone", queryParams: queryParams, body: [:], completionHandler: completionHandler)
    }
    
    public func unlinkSocialIdentitiesWithAccessToken(access_token: String, provider: String, providerid: String, completionHandler: @escaping LRAPIResponseHandler) {
        let queryParams: [String: Any] = [
            "apikey": LoginRadiusSDK.sharedInstance.apiKey,
            "access_token": access_token
        ]
        
        let body: [String: Any] = [
            "provider": provider,
            "providerid": providerid
        ]
        
        LoginRadiusREST.apiInstance.sendDELETE(url: "identity/v2/auth/socialidentity", queryParams: queryParams, body: body, completionHandler: completionHandler)
    }
    
}
