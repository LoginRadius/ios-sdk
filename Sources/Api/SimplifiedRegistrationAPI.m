//
//  SimplifiedRegistrationAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import "SimplifiedRegistrationAPI.h"

@implementation SimplifiedRegistrationAPI

+ (instancetype)simplifiedInstance{
    static dispatch_once_t onceToken;
    static SimplifiedRegistrationAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[SimplifiedRegistrationAPI alloc] init];
    });
    
    return instance;
}

- (void)simplifiedInstantRegistrationWithEmail:(NSString *)email
                                  clientguid:(NSString *)clientguid
                                        name:(NSString *)name
                                 redirecturl:(NSString *)redirecturl
                 noregistrationemailtemplate:(NSString *)noregistrationemailtemplate
                        welcomeemailtemplate:(NSString *)welcomeemailtemplate
                           completionHandler:(LRAPIResponseHandler)completion {
    NSString *_name = name ? name: @"";
    NSString *redirect_url = redirecturl ? redirecturl: @"";
    NSString *noregistration_emailtemplate = noregistrationemailtemplate ? noregistrationemailtemplate: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/noregistration/email"
                                 queryParams:@{
                                               @"apikey": [LoginRadiusSDK apiKey],
                                               @"email": email,
                                               @"clientguid": clientguid,
                                               @"name": _name,
                                               @"redirecturl": redirect_url,
                                               @"noregistrationemailtemplate": noregistration_emailtemplate,
                                               @"welcomeemailtemplate": welcome_emailtemplate
                                               }
                           completionHandler:completion];
    
}

- (void)simplifiedInstantRegistrationWithPhone:(NSString *)phone
                                        name:(NSString *)name
                                 smstemplate:(NSString *)smstemplate
                           completionHandler:(LRAPIResponseHandler)completion {
    NSString *_name = name ? name: @"";
    NSString *sms_template = smstemplate ? smstemplate: @"";

    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/noregistration/phone"
                                 queryParams:@{
                                               @"apikey": [LoginRadiusSDK apiKey],
                                               @"phone": phone,
                                               @"name": _name,
                                               @"smstemplate": sms_template
                                               }
                           completionHandler:completion];
    
}

- (void)simplifiedInstantRegistrationVerificationWithOtp:(NSString *)otp
                             phone:(NSString *)phone
                       smstemplate:(NSString *)smstemplate

                 completionHandler:(LRAPIResponseHandler)completion {
    NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/noregistration/phone/verify"
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

- (void)simplifiedInstantRegistrationPingWithClientguid:(NSString *)clientguid
                       completionHandler:(LRAPIResponseHandler)completion {
  
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/autologin/ping"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"clientguid": clientguid
                                             }
                         completionHandler:completion];
    
}


@end


