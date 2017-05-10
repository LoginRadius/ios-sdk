//
//  LoginRadiusSafariLogin.m
//  Pods
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import "LoginRadiusSafariLogin.h"
#import <SafariServices/SafariServices.h>
#import "LRClient.h"
#import "NSDictionary+LRDictionary.h"

@interface LoginRadiusSafariLogin () <SFSafariViewControllerDelegate>
@property (weak, nonatomic) SFSafariViewController *safariController;
@property (weak, nonatomic) UIViewController *viewController;
@property(nonatomic, copy) LRServiceCompletionHandler handler;
@property(nonatomic, copy) NSString* provider;
@end

@implementation LoginRadiusSafariLogin

#pragma mark Login Methods

-(void)loginWithProvider:(NSString*)provider
            inController:(UIViewController*)controller
       completionHandler:(LRServiceCompletionHandler)handler {

    self.provider = provider;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?same_window=1&is_access_token=1&apikey=%@&callbacktype=hash&provider=%@&callback=%@://auth", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], provider, [LoginRadiusSDK siteName]]];
    SFSafariViewController *sfcontroller = [[SFSafariViewController alloc] initWithURL:url];
    sfcontroller.delegate = self;
    [controller presentViewController:sfcontroller animated:NO completion:nil];
    self.safariController = sfcontroller;
    self.viewController = controller;
    self.handler = handler;
}

-(void)   initWithAction:(NSString*)action
            inController:(UIViewController*)controller
       completionHandler:(LRServiceCompletionHandler)handler {

    NSDictionary * langMap = @{@"es": @"spanish", @"de": @"german", @"fr":@"french"};
    NSString *lang = [LoginRadiusSDK sharedInstance].appLanguage;
    NSString *url_address;

    // Base version
    NSString *baseUrl = @"https://cdn.loginradius.com/hub/prod/Theme/mobile-v3/index.html";

    if (langMap[lang]) {
       baseUrl = [[NSString alloc] initWithFormat:@"https://cdn.loginradius.com/hub/prod/Theme/mobile-v3-%@/index.html",langMap[lang]];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"action": action,
                                                                                  @"sitename": [LoginRadiusSDK siteName],
                                                                                  @"apikey": [LoginRadiusSDK apiKey]
                                                                                  }];
    if ([LoginRadiusSDK v2RecaptchaSiteKey]) {
        [params setObject:[LoginRadiusSDK v2RecaptchaSiteKey] forKey:@"recaptchakey"];
    }

    NSString *urlParams = [[params copy] queryString];
    url_address = [[NSString alloc] initWithFormat:@"%@%@", baseUrl, urlParams];
    NSURL *url = [NSURL URLWithString:url_address];

    SFSafariViewController *sfcontroller = [[SFSafariViewController alloc] initWithURL:url];
    sfcontroller.delegate = self;
    [controller presentViewController:sfcontroller animated:NO completion:nil];
    self.safariController = sfcontroller;
    self.viewController = controller;
    self.handler = handler;
}

#pragma mark - Web View Delegates
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.handler(NO, [LRErrors socialLoginCancelled:_provider]);
    });
}

#pragma mark - Application Delegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    /*  <site-name>://#lr-token=<access_token>
        verify the URL is intended as a callback for social login and have access_token
     */

    BOOL isLoginRadiusURL = [[url scheme] isEqualToString:[LoginRadiusSDK siteName]] && [[url host] isEqualToString:@"auth"];
    BOOL haveAccessToken = [[url fragment] hasPrefix:@"lr-token"];
    NSString *token = [[url fragment] substringFromIndex:9];

    if( haveAccessToken ) {
        [[LRClient sharedInstance] getUserProfileWithAccessToken:token completionHandler:^(NSDictionary *data, NSError *error) {
            [self finishSocialLogin:YES	withError:error];
        }];

    } else {
        [self finishSocialLogin:NO withError:[LRErrors socialLoginFailed:self.provider]];
    }

    return isLoginRadiusURL && haveAccessToken;
}

- (void)finishSocialLogin:(BOOL)success withError:(NSError*) error {
    [self.viewController dismissViewControllerAnimated:YES completion: ^{
        if (self.handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.handler(success, error);
            });
        }
    }];
}

@end
