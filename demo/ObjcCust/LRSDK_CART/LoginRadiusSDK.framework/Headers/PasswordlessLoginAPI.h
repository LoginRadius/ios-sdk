//
//  PasswordlessLoginAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 30/07/18.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

@interface PasswordlessLoginAPI : NSObject
+(instancetype)passwordlessInstance;

- (void)passwordlessLoginWithEmail:(NSString *)email
         passwordlesslogintemplate:(NSString *)passwordlesslogintemplate
                   verificationurl:(NSString *)verificationurl
                 completionHandler:(LRAPIResponseHandler)completion;

- (void)passwordlessLoginWithUserName:(NSString *)username
            passwordlesslogintemplate:(NSString *)passwordlesslogintemplate
                      verificationurl:(NSString *)verificationurl
                    completionHandler:(LRAPIResponseHandler)completion;

- (void)passwordlessLoginVerificationWithVerificationToken:(NSString *)verificationtoken
                                     welcomeemailtemplate:(NSString *)welcomeemailtemplate
                                        completionHandler:(LRAPIResponseHandler)completion;

-(void)passwordlessLoginSendOtpWithPhone:(NSString *)phone
                             smstemplate:(NSString *)smstemplate
                       completionHandler:(LRAPIResponseHandler)completion;

-(void)passwordlessPhoneLoginWithPayload:(NSDictionary *)payload
                                  smstemplate:(NSString *)smstemplate
                            completionHandler:(LRAPIResponseHandler)completion;

@end
