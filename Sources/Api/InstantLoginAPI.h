//
//  InstantLoginAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"
@interface InstantLoginAPI : NSObject
+ (instancetype)instantLoginInstance;
- (void)instantLinkLoginWithEmail:(NSString *)email
         oneclicksignintemplate:(NSString *)oneclicksignintemplate
              completionHandler:(LRAPIResponseHandler)completion;

- (void)instantLinkLoginWithUserName:(NSString *)username
            oneclicksignintemplate:(NSString *)oneclicksignintemplate
                 completionHandler:(LRAPIResponseHandler)completion;

- (void)instantLinkLoginVerificationWithVerificationToken:(NSString *)verificationtoken
              welcomeemailtemplate:(NSString *)welcomeemailtemplate
                   completionHandler:(LRAPIResponseHandler)completion;
@end
