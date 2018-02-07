//
//  AutoLoginAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import "AutoLoginAPI.h"

@implementation AutoLoginAPI
+ (instancetype)autoLoginInstance{
    static dispatch_once_t onceToken;
    static AutoLoginAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[AutoLoginAPI alloc] init];
    });
    
    return instance;
}

- (void)autoLoginWithEmail:(NSString *)email
              clientguid:(NSString *)clientguid
              autologinemailtemplate:(NSString *)autologinemailtemplate
              welcomeemailtemplate:(NSString *)welcomeemailtemplate
              redirecturl:(NSString *)redirecturl
                        completionHandler:(LRAPIResponseHandler)completion {
    NSString *autologin_emailtemplate = autologinemailtemplate ? autologinemailtemplate: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    NSString *redirect_url = redirecturl ? redirecturl: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/autologin"
                               queryParams:@{
                                           @"apikey": [LoginRadiusSDK apiKey],
                                           @"email": email,
                                           @"clientguid": clientguid,
                                           @"autologinemailtemplate":autologin_emailtemplate,
                                           @"welcomeemailtemplate":welcome_emailtemplate,
                                           @"redirecturl":redirect_url
                                          }
                         completionHandler:completion];
    
}


- (void)autoLoginWithUsername:(NSString *)username
              clientguid:(NSString *)clientguid
  autologinemailtemplate:(NSString *)autologinemailtemplate
    welcomeemailtemplate:(NSString *)welcomeemailtemplate
             redirecturl:(NSString *)redirecturl
       completionHandler:(LRAPIResponseHandler)completion {
    NSString *autologin_emailtemplate = autologinemailtemplate ? autologinemailtemplate: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    NSString *redirect_url = redirecturl ? redirecturl: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/autologin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"username": username,
                                             @"clientguid": clientguid,
                                             @"autologinemailtemplate":autologin_emailtemplate,
                                             @"welcomeemailtemplate":redirect_url,
                                             @"redirecturl":redirect_url
                                             }
                         completionHandler:completion];
    
}

- (void)autoLoginPingWithClientguid:(NSString *)clientguid
                        completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/autologin/ping"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"clientguid": clientguid
                                             }
                         completionHandler:completion];
    
}

- (void)verifyAutoLoginEmailWithVerificationToken:(NSString *)verificationtoken
                   welcomeemailtemplate:(NSString *)welcomeemailtemplate
    completionHandler:(LRAPIResponseHandler)completion {
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/email/autologin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"verificationtoken": verificationtoken,
                                             @"welcomeemailtemplate": welcome_emailtemplate
                                             }
                         completionHandler:completion];
    
}
@end
