//
//  LoginRadiusManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusManager.h"
#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusRSViewController.h"
#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSafariLogin.h"
#import <SafariServices/SafariServices.h>
#import "LoginRadiusREST.h"
#import "LRClient.h"

@interface LoginRadiusManager() {}
@property(nonatomic, strong) LoginRadiusTwitterLogin * twitterLogin;
@property(nonatomic, strong) LoginRadiusFacebookLogin * facebookLogin;
@property(nonatomic, strong) LoginRadiusSafariLogin * safariLogin;
@property (assign, readonly, nonatomic) BOOL isSafariLogin;
@property (assign, readonly, nonatomic) BOOL isFacebookNativeLogin;
@end

@implementation LoginRadiusManager

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusManager *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusManager alloc] init];
	});

	return instance;
}

-(instancetype)init {
	self = [super init];
	if (self) {
		_twitterLogin = [[LoginRadiusTwitterLogin alloc] init];
		_facebookLogin = [[LoginRadiusFacebookLogin alloc] init];
        _safariLogin = [[LoginRadiusSafariLogin alloc] init];
	}
	return self;
}

- (void) registrationWithAction:(NSString*) action inController:(UIViewController*)controller {

    // If SafariVC exist show the traditional login and social in safari
    if ([SFSafariViewController class] != nil) {
        _isSafariLogin = YES;
        [self.safariLogin initWithAction:action inController:controller];
        return;
    }
    
	LoginRadiusRSViewController *webVC = [[LoginRadiusRSViewController alloc] initWithAction:action];
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
	[controller presentViewController:navVC animated:YES completion:nil];
}

#pragma mark Login Methods
-(void)loginWithProvider:(NSString*)provider
			inController:(UIViewController*)controller {

    // Use SFSafariViewController if available by default. Recommended approach
    if ([SFSafariViewController class] != nil) {
        _isSafariLogin = YES;
        [self.safariLogin loginWithProvider:provider inController:controller];
        return;
    }

    // Use web login
	LoginRadiusWebLoginViewController *webVC = [[LoginRadiusWebLoginViewController alloc] initWithProvider:provider];
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
	[controller presentViewController:navVC animated:YES completion:nil];
}

- (void)nativeFacebookLoginWithPermissions:(NSDictionary *)params
							  inController:(UIViewController *)controller
						 completionHandler:(LRServiceCompletionHandler)handler {

    _isFacebookNativeLogin = YES;
    
    if ([controller presentedViewController] == nil)
    {
        //if user have a native button to perform native facebook
    	[self.facebookLogin loginfromViewController:controller parameters:params handler:handler];
    }else{
    
        //if user clicked from hosted page to perform native facebook, we have to dismiss it first
        [controller dismissViewControllerAnimated:false completion: ^{[self.facebookLogin loginfromViewController:controller parameters:params handler:handler];}];
    }
    
}

- (void)nativeTwitterWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret inController:(UIViewController *)controller completionHandler:(LRServiceCompletionHandler)handler {
    [self.twitterLogin loginWithConsumerKey:consumerKey andConumerSecret:consumerSecret inController:controller completion:handler];
}

- (void)nativeGoogleLoginWithAccessToken:(NSString *)access_token completionHandler:(LRServiceCompletionHandler)handler {
    [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/access_token/google" queryParams:@{@"key": [LoginRadiusSDK apiKey], @"google_access_token" : access_token} completionHandler:^(NSDictionary *data, NSError *error) {
        NSString *token = [data objectForKey:@"access_token"];
        [[LRClient sharedInstance] getUserProfileWithAccessToken:token isNative:YES completionHandler:^(NSDictionary *data, NSError *error) {
            if (error) {
                handler(YES, error);
                return;
            }

            handler(YES, nil);
        }];
    }];

}

- (void)logout {
	// Only facebook native login stores sessions that we have to clear
	[self.facebookLogin logout];
}

#pragma mark Application delegate methods
- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
    [self.facebookLogin applicationLaunchedWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    BOOL canOpen = NO;
    
    //Handles action call from hosted page to perform native login
    if (_isFacebookNativeLogin) {
        _isFacebookNativeLogin = NO;
        canOpen = [self.facebookLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }else if (_isSafariLogin) {
        _isSafariLogin = NO;
        canOpen = [self.safariLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    if ([url.scheme isEqual: [LoginRadiusSDK siteName]] && [url host] != nil)
    {
        NSString* urlHost = [url host];
        
        if ([urlHost  isEqual: @"googleNative"] || [urlHost  isEqual: @"facebookNative"])
        {
            canOpen = true;
            
            //use userInfo to pass extra parameters on event
            [[NSNotificationCenter defaultCenter]
              postNotificationName:urlHost
              object:self
              userInfo: nil];
        }
    }

    return canOpen;
}

@end
