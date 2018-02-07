//
//  InstantLoginAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import "InstantLoginAPI.h"

@implementation InstantLoginAPI
+ (instancetype)instantLoginInstance{
    static dispatch_once_t onceToken;
    static InstantLoginAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[InstantLoginAPI alloc] init];
    });
    
    return instance;
}

- (void)instantLinkLoginWithEmail:(NSString *)email
        oneclicksignintemplate:(NSString *)oneclicksignintemplate
                   completionHandler:(LRAPIResponseHandler)completion {
     NSString *oneclicksignin_template = oneclicksignintemplate ? oneclicksignintemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/oneclicksignin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"email": email,
                                             @"oneclicksignintemplate": oneclicksignin_template,
                                             @"verificationurl":[LoginRadiusSDK verificationUrl]
                                             }
                         completionHandler:completion];
    
}

- (void)instantLinkLoginWithUserName:(NSString *)username
         oneclicksignintemplate:(NSString *)oneclicksignintemplate
              completionHandler:(LRAPIResponseHandler)completion {
    NSString *oneclicksignin_template = oneclicksignintemplate ? oneclicksignintemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/oneclicksignin"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"username": username,
                                             @"oneclicksignintemplate": oneclicksignin_template,
                                             @"verificationurl":[LoginRadiusSDK verificationUrl]
                                             }
                         completionHandler:completion];
    
}

- (void)instantLinkLoginVerificationWithVerificationToken:(NSString *)verificationtoken
            welcomeemailtemplate:(NSString *)welcomeemailtemplate
                 completionHandler:(LRAPIResponseHandler)completion {
    NSString *welcomeemail_template = welcomeemailtemplate ? welcomeemailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/oneclickverify"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"verificationtoken": verificationtoken,
                                             @"welcomeemailtemplate": welcomeemail_template,
                                             }
                         completionHandler:completion];
    
}
@end
