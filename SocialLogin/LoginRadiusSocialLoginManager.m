//
//  LoginRadiusSocialLoginManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSafariLogin.h"
#import <SafariServices/SafariServices.h>
#import "LoginRadiusREST.h"
#import "LRClient.h"

@interface LoginRadiusSocialLoginManager() {}
@property(nonatomic, strong) LoginRadiusTwitterLogin * twitterLogin;
@property(nonatomic, strong) LoginRadiusFacebookLogin * facebookLogin;
@property(nonatomic, strong) LoginRadiusSafariLogin * safariLogin;
@property (assign, readonly, nonatomic) BOOL isSafariLogin;
@property (assign, readonly, nonatomic) BOOL isFacebookNativeLogin;
@end

@implementation LoginRadiusSocialLoginManager

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusSocialLoginManager *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusSocialLoginManager alloc] init];
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

#pragma mark Login Methods
-(void)loginWithProvider:(NSString*)provider
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler {

    // Use SFSafariViewController if available by defualt. Recommended approach
    if ([SFSafariViewController class] != nil) {
        _isSafariLogin = YES;
        [self.safariLogin loginWithProvider:provider inController:controller completionHandler:handler];
        return;
    }

    // Use web login
	LoginRadiusWebLoginViewController *webVC = [[LoginRadiusWebLoginViewController alloc] initWithProvider:provider completionHandler:handler];
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
	[controller presentViewController:navVC animated:YES completion:nil];
}

- (void)nativeFacebookLoginWithPermissions:(NSDictionary *)params
							  inController:(UIViewController *)controller
						 completionHandler:(LRServiceCompletionHandler)handler {

    _isFacebookNativeLogin = YES;
	[self.facebookLogin loginfromViewController:controller parameters:params handler:handler];
}

- (void)nativeTwitterWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret inController:(UIViewController *)controller completionHandler:(LRServiceCompletionHandler)handler {
    [self.twitterLogin loginWithConsumerKey:consumerKey andConumerSecret:consumerSecret inController:controller completion:handler];
}

- (void)nativeGoogleLoginWithAccessToken:(NSString *)access_token completionHandler:(LRServiceCompletionHandler)handler {
    [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/access_token/google" queryParams:@{@"key": [LoginRadiusSDK apiKey], @"google_access_token" : access_token} completionHandler:^(NSDictionary *data, NSError *error) {
        NSString *token = [data objectForKey:@"access_token"];
        [[LRClient sharedInstance] getUserProfileWithAccessToken:token completionHandler:^(NSDictionary *data, NSError *error) {
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

    if (_isFacebookNativeLogin) {
        _isFacebookNativeLogin = NO;
        return [self.facebookLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }

    if (_safariLogin) {
        _isSafariLogin = NO;
        return [self.safariLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }

    return YES;
}

@end
