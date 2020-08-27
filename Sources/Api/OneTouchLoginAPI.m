//
//  OneTouchLoginAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 06/08/18.
//

#import "OneTouchLoginAPI.h"

@implementation OneTouchLoginAPI
+ (instancetype)oneTouchInstance{
    static dispatch_once_t onceToken;
    static OneTouchLoginAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[OneTouchLoginAPI alloc] init];
    });
    
    return instance;
}

-(void)oneTouchLoginEmailWithPayload:(NSDictionary *)payload redirecturl:(NSString *)redirecturl onetouchloginemailtemplate:(NSString *)onetouchloginemailtemplate welcomeemailtemplate:(NSString *)welcomeemailtemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *redirect_url = redirecturl ? redirecturl: @"";
    NSString *onetouchlogin_emailtemplate = onetouchloginemailtemplate ? onetouchloginemailtemplate: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/onetouchlogin/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"redirecturl": redirect_url,
                                             @"noregistrationemailtemplate": onetouchlogin_emailtemplate,
                                             @"welcomeemailtemplate": welcome_emailtemplate
                                             }
                                      body:payload
                         completionHandler:completion];
    
}

-(void)oneTouchLoginPhoneWithPayload:(NSDictionary *)payload smstemplate:(NSString *)smstemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *sms_template = smstemplate ? smstemplate: @"";
    
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/onetouchlogin/phone"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"smstemplate": sms_template
                                             }
                                         body:payload
                         completionHandler:completion];
    
}


-(void)oneTouchLoginPingWithClientguid:(NSString *)clientguid completionHandler:(LRAPIResponseHandler)completion{
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/smartlogin/ping"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"clientguid": clientguid
                                             }
                         completionHandler:completion];
    
}


-(void)oneTouchLoginVerificationWithOtp:(NSString *)otp phone:(NSString *)phone smstemplate:(NSString *)smstemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/onetouchlogin/phone/verify"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"otp":otp,
                                             @"smstemplate":sms_template
                                             }
                                      body:@{
                                             @"phone":phone
                                             }
                         completionHandler:completion];
}


-(void)oneToucEmailVerificationWithVerificationtoken:(NSString *)verificationtoken welcomeemailtemplate:(NSString *)welcomeemailtemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/email/smartlogin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"verificationtoken": verificationtoken,
                                             @"welcomeemailtemplate": welcome_emailtemplate
                                             }
                         completionHandler:completion];
    
}


@end
