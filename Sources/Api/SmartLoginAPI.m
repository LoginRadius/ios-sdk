//
//  SmartLoginAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 30/07/18.
//

#import "SmartLoginAPI.h"

@implementation SmartLoginAPI
+ (instancetype)smartLoginInstance{
    static dispatch_once_t onceToken;
    static SmartLoginAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[SmartLoginAPI alloc] init];
    });
    
    return instance;
}

- (void)smartLoginWithEmail:(NSString *)email clientguid:(NSString *)clientguid smartloginemailtemplate:(NSString *)smartloginemailtemplate welcomeemailtemplate:(NSString *)welcomeemailtemplate redirecturl:(NSString *)redirecturl completionHandler:(LRAPIResponseHandler)completion {
    NSString *smartlogin_emailtemplate = smartloginemailtemplate ? smartloginemailtemplate: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    NSString *redirect_url = redirecturl ? redirecturl: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/smartlogin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"email": email,
                                             @"clientguid": clientguid,
                                             @"smartloginemailtemplate":smartlogin_emailtemplate,
                                             @"welcomeemailtemplate":welcome_emailtemplate,
                                             @"redirecturl":redirect_url
                                             }
                         completionHandler:completion];
    
}

-(void)smartLoginWithUsername:(NSString *)username clientguid:(NSString *)clientguid smartloginemailtemplate:(NSString *)smartloginemailtemplate welcomeemailtemplate:(NSString *)welcomeemailtemplate redirecturl:(NSString *)redirecturl completionHandler:(LRAPIResponseHandler)completion{
    NSString *smartlogin_emailtemplate = smartloginemailtemplate ? smartloginemailtemplate: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    NSString *redirect_url = redirecturl ? redirecturl: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/smartlogin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"username": username,
                                             @"clientguid": clientguid,
                                             @"smartloginemailtemplate":smartlogin_emailtemplate,
                                             @"welcomeemailtemplate":welcome_emailtemplate,
                                             @"redirecturl":redirect_url
                                             }
                         completionHandler:completion];
    
}

-(void)smartLoginPingWithClientguid:(NSString *)clientguid completionHandler:(LRAPIResponseHandler)completion{
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/smartlogin/ping"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"clientguid": clientguid
                                             }
                         completionHandler:completion];
    
}

-(void)smartAutoLoginWithVerificationToken:(NSString *)verificationtoken welcomeemailtemplate:(NSString *)welcomeemailtemplate completionHandler:(LRAPIResponseHandler)completion{
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
