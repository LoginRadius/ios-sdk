//
//  AutoLoginAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

@interface AutoLoginAPI : NSObject
+ (instancetype)autoLoginInstance;

- (void)autoLoginWithEmail:(NSString *)email
              clientguid:(NSString *)clientguid
  autologinemailtemplate:(NSString *)autologinemailtemplate
    welcomeemailtemplate:(NSString *)welcomeemailtemplate
             redirecturl:(NSString *)redirecturl
       completionHandler:(LRAPIResponseHandler)completion;

- (void)autoLoginWithUsername:(NSString *)username
                 clientguid:(NSString *)clientguid
     autologinemailtemplate:(NSString *)autologinemailtemplate
       welcomeemailtemplate:(NSString *)welcomeemailtemplate
                redirecturl:(NSString *)redirecturl
          completionHandler:(LRAPIResponseHandler)completion;


- (void)autoLoginPingWithClientguid:(NSString *)clientguid
    completionHandler:(LRAPIResponseHandler)completion;

- (void)verifyAutoLoginEmailWithVerificationToken:(NSString *)verificationtoken
                welcomeemailtemplate:(NSString *)welcomeemailtemplate
                   completionHandler:(LRAPIResponseHandler)completion;
@end
