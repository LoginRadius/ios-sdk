//
//  LoginRadiusSafariLogin.m
//  Pods
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import "LoginRadiusSafariLogin.h"
#import "LoginRadiusRegistrationManager.h"
#import <SafariServices/SafariServices.h>

@interface LoginRadiusSafariLogin () <SFSafariViewControllerDelegate>
@property (weak, nonatomic) SFSafariViewController *safariController;
@property (weak, nonatomic) UIViewController *viewController;
@property(nonatomic, copy) LRAPIResponseHandler handler;
@property(nonatomic, copy) NSString* provider;
@end

@implementation LoginRadiusSafariLogin

#pragma mark Login Methods

-(void)loginWithProvider:(NSString*)provider
            inController:(UIViewController*)controller
       completionHandler:(LRAPIResponseHandler)handler {

    self.provider = [provider lowercaseString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?same_window=1&is_access_token=1&apikey=%@&callbacktype=hash&provider=%@&callback=%@.%@://", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], [self provider], [LoginRadiusSDK siteName],[[NSBundle mainBundle] bundleIdentifier]]];
    SFSafariViewController *sfcontroller = [[SFSafariViewController alloc] initWithURL:url];
    sfcontroller.delegate = self;
    [controller presentViewController:sfcontroller animated:NO completion:nil];
    self.safariController = sfcontroller;
    self.viewController = controller;
    self.handler = handler;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    // <site-name>://#lr-token=<access_token>
    // verify the URL is intended as a callback for social login and have access_token

    NSString *siteNameAndBundleID = [NSString stringWithFormat:@"%@.%@",[LoginRadiusSDK siteName],[[NSBundle mainBundle] bundleIdentifier]];
    BOOL isLoginRadiusURL = [[url scheme] isEqualToString:siteNameAndBundleID] && [[url host] isEqualToString:@"auth"];
    BOOL haveAccessToken = [[url fragment] hasPrefix:@"lr-token"];
    NSString *token = [[url fragment] substringFromIndex:9];

    if( haveAccessToken ) {
        [[LoginRadiusRegistrationManager sharedInstance] authProfilesByToken:token completionHandler:^(NSDictionary *data, NSError *error) {
        
            [self finishSocialLogin:data withError:error];
        }];

    } else {
        [self finishSocialLogin:nil withError:[LRErrors socialLoginFailed:self.provider]];
    }

    return isLoginRadiusURL && haveAccessToken;
}

- (void)finishSocialLogin:(NSDictionary * _Nullable)data withError:(NSError*) error {
    [self.viewController dismissViewControllerAnimated:YES completion: ^{
        if (self.handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.handler(data, error);
            });
        }
    }];
}

@end
