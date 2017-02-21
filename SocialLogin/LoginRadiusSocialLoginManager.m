//
//  LoginRadiusSocialLoginManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusWebLoginViewController.h"

@interface LoginRadiusSocialLoginManager() {}
@property(nonatomic, strong) LoginRadiusTwitterLogin * twitterLogin;
@property(nonatomic, strong) LoginRadiusFacebookLogin * facebookLogin;
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
	}
	return self;
}

#pragma mark Login Methods
-(void)loginWithProvider:(NSString*)provider
			  parameters:(NSDictionary*)params
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler {

	// Use web login
	LoginRadiusWebLoginViewController *webVC = [[LoginRadiusWebLoginViewController alloc] initWithProvider:provider completionHandler:handler];
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
	[controller presentViewController:navVC animated:YES completion:nil];
}

- (void)nativeFacebookLoginWithPermissions:(NSDictionary *)params
							  inController:(UIViewController *)controller
						 completionHandler:(LRServiceCompletionHandler)handler {
	[self.facebookLogin loginfromViewController:controller parameters:params handler:handler];
}

- (void)nativeTwitterLoginWithPermissions:(NSDictionary *)params
							 inController:(UIViewController *)controller
						completionHandler:(LRServiceCompletionHandler)handler {
	[self.twitterLogin login:handler];
}

- (void)logout {
	// Only facebook native login stores sessions that we have to clear
	[self.facebookLogin logout];
}

#pragma mark Application delegate methods
- (BOOL)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
	return [self.facebookLogin applicationLaunchedWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return [self.facebookLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
