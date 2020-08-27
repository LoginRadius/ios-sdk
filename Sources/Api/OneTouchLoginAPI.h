//
//  OneTouchLoginAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 06/08/18.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

@interface OneTouchLoginAPI : NSObject
+ (instancetype)oneTouchInstance;

- (void)oneTouchLoginEmailWithPayload:(NSDictionary *)payload
                                   redirecturl:(NSString *)redirecturl
                   onetouchloginemailtemplate:(NSString *)onetouchloginemailtemplate
                          welcomeemailtemplate:(NSString *)welcomeemailtemplate
                             completionHandler:(LRAPIResponseHandler)completion;


- (void)oneToucEmailVerificationWithVerificationtoken:(NSString *)verificationtoken
          welcomeemailtemplate:(NSString *)welcomeemailtemplate
             completionHandler:(LRAPIResponseHandler)completion;


- (void)oneTouchLoginPhoneWithPayload:(NSDictionary *)payload
                                   smstemplate:(NSString *)smstemplate
                             completionHandler:(LRAPIResponseHandler)completion;


- (void)oneTouchLoginVerificationWithOtp:(NSString *)otp
                                                   phone:(NSString *)phone
                                             smstemplate:(NSString *)smstemplate
                                       completionHandler:(LRAPIResponseHandler)completion;


- (void)oneTouchLoginPingWithClientguid:(NSString *)clientguid
                                      completionHandler:(LRAPIResponseHandler)completion;
@end
