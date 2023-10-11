//
//  LoginRadiusTwitterLogin.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusREST.h"
#import "LRErrors.h"
#import "LoginRadius.h"

@interface LoginRadiusTwitterLogin()
@property(nonatomic, copy) LRAPIResponseHandler handler;
@property BOOL EmailVerified;
@property BOOL PhoneIdVerified;
@property(nonatomic, strong) UIViewController * viewController;
@end

@implementation LoginRadiusTwitterLogin

- (void)getLRTokenWithTwitterToken:(NSString*)twitter_token
                     twitterSecret:(NSString*)twitter_secret
 withSocialAppName:(NSString *)socialAppName
                      inController:(UIViewController *)controller
                           handler:(LRAPIResponseHandler)handler{
    self.handler = handler;
    self.viewController = controller;
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionaryWithDictionary:@{@"key": [LoginRadiusSDK apiKey],
    @"tw_access_token" : twitter_token,
    @"tw_token_secret":twitter_secret
    }];
     if(socialAppName && [socialAppName length]) {
              [dictParam setValue:socialAppName forKey:@"socialappname"];
          }
         
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/access_token/twitter"
                               queryParams:dictParam
                         completionHandler:^(NSDictionary *data, NSError *error) {
                            
                           [self finishLogin:data withError:error];
                             
                         }];
}


- (void)finishLogin:(NSDictionary*)data withError:(NSError*)error {
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(data, error);
        });
    }
}
@end

