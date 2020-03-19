//
//  SmartLoginAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 30/07/18.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

@interface SmartLoginAPI : NSObject
+(instancetype)smartLoginInstance;

- (void)smartLoginWithEmail:(NSString *)email
                clientguid:(NSString *)clientguid
    smartloginemailtemplate:(NSString *)smartloginemailtemplate
      welcomeemailtemplate:(NSString *)welcomeemailtemplate
               redirecturl:(NSString *)redirecturl
         completionHandler:(LRAPIResponseHandler)completion;

- (void)smartLoginWithUsername:(NSString *)username
                   clientguid:(NSString *)clientguid
       smartloginemailtemplate:(NSString *)smartloginemailtemplate
         welcomeemailtemplate:(NSString *)welcomeemailtemplate
                  redirecturl:(NSString *)redirecturl
            completionHandler:(LRAPIResponseHandler)completion;

- (void)smartLoginPingWithClientguid:(NSString *)clientguid
                  completionHandler:(LRAPIResponseHandler)completion;

- (void)smartAutoLoginWithVerificationToken:(NSString *)verificationtoken
                             welcomeemailtemplate:(NSString *)welcomeemailtemplate
                                completionHandler:(LRAPIResponseHandler)completion;

@end
