//
//  LoginRadiusFacebookLogin.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusREST.h"
#import "LoginRadiusUtilities.h"

@interface LoginRadiusFacebookLogin ()
@end

@implementation LoginRadiusFacebookLogin
+ (instancetype) sharedInstance {
	return [LoginRadiusFacebookLogin instanceWithApplication:nil launchOptions:nil];
}

+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	static dispatch_once_t onceToken;
	static LoginRadiusFacebookLogin *instance;
	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusFacebookLogin alloc] initWithApplication:application launchOptions:launchOptions];
	});
	return instance;
}

- (instancetype)initWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	self = [super init];
	if(self) {
		[(FBSDKApplicationDelegate *)[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
	}
	return self;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
																  openURL:url
														sourceApplication:sourceApplication
															   annotation:annotation
					];
	return handled;
}

- (void)loginfromViewController:(UIViewController*)controller handler:(loginResult)handler {
	FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
	facebookLogin.loginBehavior = FBSDKLoginBehaviorSystemAccount;
	// TODO: Right now asking for default permissions, need to ask for permissions set in user portal
	[facebookLogin logInWithReadPermissions:@[@"email"] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
		if (error) {
			NSLog(@"Facebook login failed. Error: %@", error);
		} else if (result.isCancelled) {
			NSLog(@"Facebook login got cancelled.");
		} else {
			NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
			// Get loginradius access_token for facebook access_token
			[[LoginRadiusREST sharedInstance] callAPIEndpoint:@"api/v2/access_token/facebook" method:@"GET" params:@{@"key": [LoginRadiusSDK apiKey], @"fb_access_token" : accessToken} completionHandler:^(NSDictionary *data, NSError *error) {
				NSString *token = [data objectForKey:@"access_token"];
				if ([LoginRadiusUtilities lrSaveUserData:nil lrToken:token]) {
					NSLog(@"User successfully saved");
				}
			}];
		}
	}];
}

@end
