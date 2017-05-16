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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?same_window=1&is_access_token=1&apikey=%@&callbacktype=hash&provider=%@&callback=%@://", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], provider, [LoginRadiusSDK siteName]]];
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

    NSString *url_address;

    // Base version
    NSString *baseUrl = [LoginRadiusSDK hostedPageURL];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"action": action,
                                                                                  @"sitename": [LoginRadiusSDK siteName],
                                                                                  @"apikey": [LoginRadiusSDK apiKey],
                                                                                  @"customRedirect": @"true"
                                                                                  }];
    if ([LoginRadiusSDK v2RecaptchaSiteKey]) {
        [params setObject:[LoginRadiusSDK v2RecaptchaSiteKey] forKey:@"recaptchakey"];
    }
    
    if ([LoginRadiusSDK useGoogleNativeLogin]) {
        [params setObject: @"true" forKey:@"googleNative"];
    }
    
    if ([LoginRadiusSDK useFacebookNativeLogin]) {
        [params setObject: @"true" forKey:@"facebookNative"];
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

    BOOL isLoginRadiusURL = [[url scheme] isEqualToString:[LoginRadiusSDK siteName]];
    
    if ([url fragment] != nil)
    {
        //Check if its from hub page
        [self handleResponseFromHubPage: url];
    }else if ([url host] != nil && [url query] != nil)
    {
        //Check if its from hosted page
        [self handleResponseFromHostedPage:url withAction:[url host]];
    }
    
    return isLoginRadiusURL;
}

- (void)handleResponseFromHubPage:(NSURL *) url
{
    BOOL haveAccessTokenFromHubPage = [[url fragment] hasPrefix:@"lr-token"];
    
    if (haveAccessTokenFromHubPage)
    {
        NSString *tokenFromHub = [[url fragment] substringFromIndex:9];
        [self fetchUserProfileWithToken:tokenFromHub];
    }else{
        [self finishRaasAction:NO withError:[LRErrors userLoginFailed]];
    }
}

- (void)handleResponseFromHostedPage:(NSURL *) url
                          withAction:(NSString *) returnAction
{
	NSDictionary *params = [NSDictionary dictionaryWithQueryString:url.query];
    //TODO: re-implement using do try catch error
    if( [returnAction isEqualToString:@"registration"]) {
    
        BOOL success = [[params objectForKey:@"success"] boolValue];
        
        if (success) {
            [self finishRaasAction:YES withError:nil];
        } else {
            [self finishRaasAction:NO withError:[LRErrors userRegistrationFailed]];
        }
	} else if( [returnAction isEqualToString:@"login"] ) {

		if ([url.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];
            if (lrtoken) {
                [self fetchUserProfileWithToken:lrtoken];
            } else {
                [self finishRaasAction:NO withError:[LRErrors userProfileError]];
            }
		}else{
            [self finishRaasAction:NO withError:[LRErrors userProfileError]];
        }

	} else if ( [returnAction isEqualToString:@"forgotpassword"] ) {

		BOOL success = [[params objectForKey:@"success"] boolValue];
        
        if (success) {
            [self finishRaasAction:YES withError:nil];
        } else {
            [self finishRaasAction:NO withError:[LRErrors userForgotPasswordFailed]];
        }

	} else if ( [returnAction isEqualToString:@"sociallogin"] ) {

		if ([url.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];

            if (lrtoken) {
                [self fetchUserProfileWithToken: lrtoken];
            } else {
                [self finishRaasAction:NO withError:[LRErrors userProfileError]];
            }
		}else{
            [self finishRaasAction:NO withError:[LRErrors userProfileError]];
        }

	}  else {
    
        [self finishRaasAction:NO withError:[LRErrors unsupportedAction]];
	}
}

- (void)fetchUserProfileWithToken:(NSString*)token
{
    [[LRClient sharedInstance] getUserProfileWithAccessToken:token completionHandler:^(NSDictionary *data, NSError *error) {
        [self finishRaasAction:YES	withError:error];
    }];
}

- (void)finishRaasAction:(BOOL)success withError:(NSError*) error {
    [self.viewController dismissViewControllerAnimated:YES completion: ^{
        if (self.handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.handler(success, error);
            });
        }
    }];
}

@end
