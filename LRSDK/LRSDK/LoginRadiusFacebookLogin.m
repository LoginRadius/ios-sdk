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

- (void)loginfromViewController:(UIViewController*)controller
					 parameters:(NSDictionary*)params
						handler:(responseHandler)handler {

	BOOL permissionsAllowed = YES;
	NSArray *permissions;

	if (params[@"facebookPermissions"]) {
		permissions = params[@"facebookPermissions"];
	} else {
		NSLog(@"permissions not set using basic permissions");
		permissions = @[@"public_profile"];
	}

	FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
	FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
	login.loginBehavior = params[@"facebookLoginBehavior"] || FBSDKLoginBehaviorSystemAccount;

	void (^handleLogin)(FBSDKLoginManagerLoginResult *result, NSError *error) = ^void(FBSDKLoginManagerLoginResult *result, NSError *error) {
		[self onLoginResult:result callback:handler error:error];
	};

	if (token) {
		// remove permissions that the user already has
		permissions = [permissions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			return ![token.permissions containsObject:evaluatedObject];
		}]];

		BOOL publishPermissionFound = NO;
		BOOL readPermissionFound = NO;
		for (NSString *p in permissions) {
			if ([self isPublishPermission:p]) {
				publishPermissionFound = YES;
			} else {
				readPermissionFound = YES;
			}
		}

		if ([permissions count] == 0) {
			[self finishLogin:handler];
		} else if (publishPermissionFound && readPermissionFound) {
			// Mix of permissions, not allowed
			permissionsAllowed = NO;
			NSLog(@"Your app can't ask for both read and write permissions.");
		} else if (publishPermissionFound) {
			// Only publish permissions
			[login logInWithPublishPermissions:permissions fromViewController:controller handler:handleLogin];
		} else {
			// Only read permissions
			[login logInWithReadPermissions:permissions fromViewController:controller handler:handleLogin];
		}
	} else {
		// Initial log in, can only ask for read type permissions
		NSLog(@"{facebook} requesting initial login");
		if ([self areAllPermissionsReadPermissions:permissions]) {
			[login logInWithReadPermissions:permissions fromViewController:controller handler:handleLogin];
		} else {
			permissionsAllowed = NO;
			NSLog(@"You can only ask for read permissions initially");
		}
	}

	if (!permissionsAllowed) {
		NSLog(@"You can only ask for read permissions for the first time login");
	}
}

- (void) onLoginResult:(FBSDKLoginManagerLoginResult *) result
			  callback:(responseHandler)handler
				 error:(NSError *)error {

	if (error) {
		NSLog(@"Facebook login failed. Error: %@", error);
	} else if (result.isCancelled) {
		NSLog(@"Facebook login got cancelled.");
	} else {
		// all other cases are handled by the access token notification
		NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
		// Get loginradius access_token for facebook access_token
		[[LoginRadiusREST sharedInstance] callAPIEndpoint:@"api/v2/access_token/facebook" method:@"GET" params:@{@"key": [LoginRadiusSDK apiKey], @"fb_access_token" : accessToken} completionHandler:^(NSDictionary *data, NSError *error) {
			NSString *token = [data objectForKey:@"access_token"];
			if ([LoginRadiusUtilities lrSaveUserData:nil lrToken:token]) {
				NSLog(@"User successfully saved");
			}
		}];
	}
}

- (void) logout {
	if ([FBSDKAccessToken currentAccessToken]) {
		FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
		[login logOut];
		NSLog(@"Logged out");
	} else {
		NSLog(@"Not logged in");
	}
}

- (BOOL) isPublishPermission:(NSString*)permission {
	return [permission hasPrefix:@"ads_management"] ||
	[permission hasPrefix:@"manage_notifications"] ||
	[permission isEqualToString:@"publish_actions"] ||
	[permission isEqualToString:@"manage_pages"] ||
	[permission isEqualToString:@"rsvp_event"];
}

- (BOOL) areAllPermissionsReadPermissions:(NSArray*)permissions {
	for (NSString *permission in permissions) {
		if ([self isPublishPermission:permission]) {
			return NO;
		}
	}
	return YES;
}

- (void)finishLogin:(responseHandler)handler {
	FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
	NSTimeInterval expiresTimeInterval = [token.expirationDate timeIntervalSinceNow];
	NSNumber* expiresIn = @0;
	if (expiresTimeInterval > 0) {
		expiresIn = [NSNumber numberWithDouble:expiresTimeInterval];
	}

	NSString * userID = token ? token.userID : @"";
	if (token) {
		// Build an object that matches the javascript response
		NSDictionary * authData = @{
									@"accessToken": token.tokenString,
									@"expiresIn": expiresIn,
									@"grantedScopes": [[[token permissions] allObjects] componentsJoinedByString:@","],
									@"declinedScopes": [[[token declinedPermissions] allObjects] componentsJoinedByString:@","],
									@"userID": userID
									};

		handler(@{@"status": @"connected", @"authResponse": authData}, nil);
	}
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	@try {
		BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
																	  openURL:url
															sourceApplication:sourceApplication
																   annotation:annotation];
		return handled;
	} @catch (NSException *exception) {
		NSLog(@"{facebook} Exception while processing openurl event: %@", exception);
	}

}

@end
