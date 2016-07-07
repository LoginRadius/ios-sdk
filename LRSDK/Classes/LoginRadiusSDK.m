//
//  LoginRadiusSDK.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSDK.h"
#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusRegistrationManager.h"

@interface LoginRadiusSDK()
@property(nonatomic, copy) NSString* apiKey;
@property(nonatomic, copy) NSString* siteName;
@end

@implementation LoginRadiusSDK
@synthesize appLanguage;

- (void)setUseNativeSocialLogin:(BOOL)useNativeSocialLogin {
	_useNativeSocialLogin = useNativeSocialLogin;
	[LoginRadiusSocialLoginManager sharedInstance].useNativeLogin = useNativeSocialLogin;
}

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusSDK *instance;
	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusSDK alloc] init];
	});

	return instance;
}

+ (void)instanceWithAPIKey:(NSString *)apiKey siteName:(NSString *)siteName application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	[LoginRadiusSDK sharedInstance].apiKey = apiKey;
	[LoginRadiusSDK sharedInstance].siteName = siteName;
	[LoginRadiusSocialLoginManager instanceWithApplication:application launchOptions:launchOptions];
	[LoginRadiusRegistrationManager instanceWithApplication:application launchOptions:launchOptions];
	[LoginRadiusSDK sharedInstance].useNativeSocialLogin = NO;
}

+ (void) socialLoginWithProvider:(NSString*)provider
					  parameters:(NSDictionary*)params
					inController:(UIViewController*)controller
			   completionHandler:(LRServiceCompletionHandler)handler {
	[[LoginRadiusSocialLoginManager sharedInstance] loginWithProvider:provider
														   parameters:params
														 inController:controller
													completionHandler:handler];
}

+ (void) registrationServiceWithAction:(NSString*) action
						  inController:(UIViewController*)controller
					 completionHandler:(LRServiceCompletionHandler)handler {
	[[LoginRadiusRegistrationManager sharedInstance] registrationWithAction:action
															   inController:controller
														  completionHandler:handler];
}

+ (void) logout {
	[[LoginRadiusSocialLoginManager sharedInstance] logout];
	// Clearing all stored tokens userprofiles for loginradius
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}

	NSUserDefaults *lrUserDefault = [NSUserDefaults standardUserDefaults];
	[lrUserDefault removeObjectForKey:@"isLoggedIn"];
	[lrUserDefault removeObjectForKey:@"lrAccessToken"];
	[lrUserDefault removeObjectForKey:@"lrUserBlocked"];
	[lrUserDefault removeObjectForKey:@"lrUserProfile"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) apiKey {
	return [LoginRadiusSDK sharedInstance].apiKey;
}

+ (NSString*) siteName {
	return [LoginRadiusSDK sharedInstance].siteName;
}

#pragma mark Application Delegate methods
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	if ([[LoginRadiusSocialLoginManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
		return YES;
	}
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end
