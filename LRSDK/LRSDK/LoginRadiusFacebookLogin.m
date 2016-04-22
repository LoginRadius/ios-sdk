//
//  LoginRadiusFacebookLogin.m
//  LoginRadius
//
//  Created by Raviteja Ghanta on 14/04/16.
//  Copyright © 2016 LoginRadius. All rights reserved.
//

#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusREST.h"

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
	[facebookLogin logInWithReadPermissions:@[@"email"] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
		if (error) {
			NSLog(@"Facebook login failed. Error: %@", error);
		} else if (result.isCancelled) {
			NSLog(@"Facebook login got cancelled.");
		} else {
			NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
			// Get loginradius access_token for facebook access_token
		}
	}];
}

@end
