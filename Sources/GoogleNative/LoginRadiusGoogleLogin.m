//
//  LoginRadiusGoogleLogin.m
//  LoginRadiusSDK
//
//  Created by Thompson Sanjoto on 2017-09-22.
//

#import "LoginRadiusGoogleLogin.h"
#import "LoginRadiusREST.h"
#import "LRClient.h"
#import "LRErrors.h"
#import "LoginRadiusSafariLogin.h"
#import "NSDictionary+LRDictionary.h"

@interface LoginRadiusGoogleLogin ()
@property(nonatomic, copy) LRServiceCompletionHandler handler;
@property(nonatomic, strong) LoginRadiusSafariLogin * safariLogin;
@property(nonatomic, strong) UIViewController * viewController;
@end

@implementation LoginRadiusGoogleLogin

-(instancetype)init {
    self = [super init];
    if (self) {
        _safariLogin = [[LoginRadiusSafariLogin alloc] init];
    }
    return self;
}

- (void)convertGoogleTokenToLRToken :(NSString*)google_token
                            inController:(UIViewController *)controller
                                 handler:(LRServiceCompletionHandler) handler {
    self.handler = handler;
    self.viewController = controller;
     [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/access_token/google" queryParams:@{@"key": [LoginRadiusSDK apiKey], @"google_access_token" : google_token} completionHandler:^(NSDictionary *data, NSError *error) {
        NSString *token = [data objectForKey:@"access_token"];
        
        if([LoginRadiusSDK nativeSocialAskForRequiredFields]){
            [[NSNotificationCenter defaultCenter] addObserver:self
             selector:@selector(returnFromValidation:)
                 name:@"returnFromHostedValidation"
               object:nil];
            
            //validate user profile on hosted page
            [_safariLogin initWithAction:@"sociallogin" accessToken:token inController:controller];
        }else{
            [self getUserProfileAndPerformCallback:token];
        }
    }];
}

- (void) returnFromValidation:(NSNotification *)notification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"returnFromHostedValidation" object:nil];
    
    NSDictionary *userInfo = [notification userInfo];
    NSString *queryString = [userInfo objectForKey:@"query"];
    NSDictionary *dict = [NSDictionary dictionaryWithQueryString:queryString];
    NSString *token = [dict objectForKey:@"lrtoken"];
    
    [self.viewController.parentViewController dismissViewControllerAnimated:NO completion:^{
        [self getUserProfileAndPerformCallback:token];
    }];
}

- (void) userCancelledValidation:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lr-usercancelled" object:nil];
    NSDictionary *userInfo = [notification userInfo];
    NSError *error = [userInfo objectForKey:@"error"];
    [self finishLogin:false withError:error];
}

- (void) getUserProfileAndPerformCallback: (NSString *) token{
    [[LRClient sharedInstance] getUserProfileWithAccessToken:token isNative:YES completionHandler:^(NSDictionary *data, NSError *error) {
        [self finishLogin:(error==nil) withError:error];
    }]; 
}

- (void)finishLogin:(BOOL) success withError:(NSError*) error {
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(success, error);
        });
    }
}

@end
