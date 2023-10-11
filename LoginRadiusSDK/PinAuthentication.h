//
//  PinAuthentication.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 21/08/19.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"
#import "LRDictionary.h"

@interface PinAuthentication : NSObject
+ (instancetype)pinAuthInstance;

- (void)loginWithPin:(NSString *)session_token
                        payload:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion;

- (void)setPinWithPinAuthToken:(NSString *)session_token
             pin:(NSString *)pin
   completionHandler:(LRAPIResponseHandler)completion;

- (void)forgotPinWithEmail:(NSString *)email
             emailtemplate:(NSString *)emailtemplate
               resetpinurl:(NSString *)resetpinurl
             completionHandler:(LRAPIResponseHandler)completion;

- (void)forgotPinWithUserName:(NSString *)username
             emailtemplate:(NSString *)emailtemplate
               resetpinurl:(NSString *)resetpinurl
         completionHandler:(LRAPIResponseHandler)completion;

- (void)forgotPinWithPhone:(NSString *)phone
             smstemplate:(NSString *)smstemplate
         completionHandler:(LRAPIResponseHandler)completion;

- (void)invalidatePinSessionToken:(NSString *)session_token
         completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithEmailAndOtp:(NSDictionary *)payload
                completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithUserNameAndOtp:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithPhoneAndOtp:(NSDictionary *)payload
                 completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithResetToken:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithSecurityAnswerAndEmail:(NSDictionary *)payload
             completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithSecurityAnswerAndUserName:(NSDictionary *)payload
                         completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPinWithSecurityAnswerAndPhone:(NSDictionary *)payload
                         completionHandler:(LRAPIResponseHandler)completion;

- (void)changePinWithAccessToken:(NSString *)access_token
                         payload:(NSDictionary *)payload
                         completionHandler:(LRAPIResponseHandler)completion;

@end

