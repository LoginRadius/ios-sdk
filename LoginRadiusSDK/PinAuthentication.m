//
//  PinAuthentication.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 21/08/19.
//

#import "PinAuthentication.h"

@implementation PinAuthentication
+ (instancetype)pinAuthInstance{
    static dispatch_once_t onceToken;
    static PinAuthentication *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[PinAuthentication alloc] init];
    });
    
    return instance;
}

- (void)loginWithPin:(NSString *)session_token
                        payload:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion {
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/login/pin"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"session_token": session_token
                                              }
                                       body:payload
                          completionHandler:completion];
}
    
- (void)setPinWithPinAuthToken:(NSString *)pinAuthToken
                        pin:(NSString *)pin
              completionHandler:(LRAPIResponseHandler)completion {
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/pin/set/pinauthtoken"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"pinauthtoken": pinAuthToken
                                              }
                                       body:@{
                                              @"pin":pin
                                              }
                          completionHandler:completion];
}

- (void)forgotPinWithEmail:(NSString *)email
                           emailtemplate:(NSString *)emailtemplate
                           resetpinurl:(NSString *)resetpinurl
             completionHandler:(LRAPIResponseHandler)completion {
    NSString *email_template = emailtemplate ? emailtemplate: @"";
    NSString *reset_pinurl = resetpinurl ? resetpinurl: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/pin/forgot/email"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"emailtemplate": email_template,
                                              @"resetpinurl": reset_pinurl
                                              }
                                       body:@{
                                              @"email":email
                                              }
                          completionHandler:completion];
}

- (void)forgotPinWithUserName:(NSString *)username
             emailtemplate:(NSString *)emailtemplate
               resetpinurl:(NSString *)resetpinurl
         completionHandler:(LRAPIResponseHandler)completion {
    NSString *email_template = emailtemplate ? emailtemplate: @"";
    NSString *reset_pinurl = resetpinurl ? resetpinurl: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/pin/forgot/username"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"emailtemplate": email_template,
                                              @"resetpinurl": reset_pinurl
                                              }
                                       body:@{
                                              @"username":username
                                              }
                          completionHandler:completion];
}

- (void)forgotPinWithPhone:(NSString *)phone
               smstemplate:(NSString *)smstemplate
         completionHandler:(LRAPIResponseHandler)completion {
    NSString *sms_template = smstemplate ? smstemplate: @"";

    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/pin/forgot/otp"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"smstemplate": sms_template
                                              }
                                       body:@{
                                              @"phone":phone
                                              }
                          completionHandler:completion];
}

- (void)invalidatePinSessionToken:(NSString *)session_token
                completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/session_token/invalidate"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"session_token": session_token
                                              }
     
                          completionHandler:completion];
}

- (void)resetPinWithEmailAndOtp:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/otp/email"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey]
                                              }
                                       body:payload
                          completionHandler:completion];
}

- (void)resetPinWithUserNameAndOtp:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/otp/username"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPinWithPhoneAndOtp:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/otp/phone"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPinWithResetToken:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/token"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPinWithSecurityAnswerAndEmail:(NSDictionary *)payload
             completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/securityanswer/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPinWithSecurityAnswerAndUserName:(NSDictionary *)payload
                         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/securityanswer/username"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPinWithSecurityAnswerAndPhone:(NSDictionary *)payload
                            completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/reset/securityanswer/phone"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)changePinWithAccessToken:(NSString *)access_token
                         payload:(NSDictionary *)payload
                         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/pin/change"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token
                                             }
                                      body:payload
                         completionHandler:completion];
}
@end
