//
//  PasswordlessLoginAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 30/07/18.
//

#import "PasswordlessLoginAPI.h"

@implementation PasswordlessLoginAPI
+ (instancetype)passwordlessInstance{
    static dispatch_once_t onceToken;
    static PasswordlessLoginAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[PasswordlessLoginAPI alloc] init];
    });
    
    return instance;
}

-(void)passwordlessLoginWithEmail:(NSString *)email passwordlesslogintemplate:(NSString *)passwordlesslogintemplate verificationurl:(NSString *)verificationurl completionHandler:(LRAPIResponseHandler)completion {
    NSString *passwordlesslogin_template = passwordlesslogintemplate ? passwordlesslogintemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/passwordlesslogin/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"email": email,
                                             @"passwordlesslogintemplate": passwordlesslogin_template,
                                             @"verificationurl":[LoginRadiusSDK verificationUrl]
                                             }
                         completionHandler:completion];
}
    
-(void)passwordlessLoginWithUserName:(NSString *)username passwordlesslogintemplate:(NSString *)passwordlesslogintemplate verificationurl:(NSString *)verificationurl completionHandler:(LRAPIResponseHandler)completion{
    NSString *passwordlesslogin_template = passwordlesslogintemplate ? passwordlesslogintemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/passwordlesslogin/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"username": username,
                                             @"passwordlesslogintemplate": passwordlesslogin_template,
                                             @"verificationurl":[LoginRadiusSDK verificationUrl]
                                             }
                         completionHandler:completion];
    
}

-(void)passwordlessLoginVerificationWithVerificationToken:(NSString *)verificationtoken welcomeemailtemplate:(NSString *)welcomeemailtemplate completionHandler:(LRAPIResponseHandler)completion {
    NSString *welcomeemail_template = welcomeemailtemplate ? welcomeemailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/passwordlesslogin/email/verify"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"verificationtoken": verificationtoken,
                                             @"welcomeemailtemplate": welcomeemail_template
                                             }
                         completionHandler:completion];
    
}


-(void)passwordlessLoginSendOtpWithPhone:(NSString *)phone smstemplate:(NSString *)smstemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/passwordlesslogin/otp"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"phone": phone,
                                             @"smstemplate": sms_template
                                             }
                         completionHandler:completion];
    
}

-(void)passwordlessPhoneLoginWithPayload:(NSDictionary *)payload smstemplate:(NSString *)smstemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/login/passwordlesslogin/otp/verify"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"smstemplate": sms_template
                                             }
                                      body:payload
                         completionHandler:completion];
}

@end
