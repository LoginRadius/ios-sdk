//
//  SimplifiedRegistrationAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

@interface SimplifiedRegistrationAPI : NSObject
+ (instancetype)simplifiedInstance;

- (void)simplifiedInstantRegistrationWithEmail:(NSString *)email
                                    clientguid:(NSString *)clientguid
                                          name:(NSString *)name
                                   redirecturl:(NSString *)redirecturl
                   noregistrationemailtemplate:(NSString *)noregistrationemailtemplate
                          welcomeemailtemplate:(NSString *)welcomeemailtemplate
                             completionHandler:(LRAPIResponseHandler)completion;


- (void)simplifiedInstantRegistrationWithPhone:(NSString *)phone
                                          name:(NSString *)name
                                   smstemplate:(NSString *)smstemplate
                             completionHandler:(LRAPIResponseHandler)completion;


- (void)simplifiedInstantRegistrationVerificationWithOtp:(NSString *)otp
                                                   phone:(NSString *)phone
                                             smstemplate:(NSString *)smstemplate
                                       completionHandler:(LRAPIResponseHandler)completion;


- (void)simplifiedInstantRegistrationPingWithClientguid:(NSString *)clientguid
                                      completionHandler:(LRAPIResponseHandler)completion;


@end

