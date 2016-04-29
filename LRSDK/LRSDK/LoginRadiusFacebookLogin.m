//
//  LoginRadiusFacebookLogin.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusREST.h"
#import "LoginRadiusUtilities.h"

@interface LoginRadiusFacebookLogin ()
@property(nonatomic, copy) LRServiceCompletionHandler handler;
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
						handler:(LRServiceCompletionHandler)handler {

	BOOL permissionsAllowed = YES;
	NSArray *permissions;
	self.handler = handler;

	if (params[@"facebookPermissions"]) {
		permissions = params[@"facebookPermissions"];
	} else {
		// permissions not set using basic permissions;
		permissions = @[@"public_profile"];
	}

	FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
	FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
	login.loginBehavior = params[@"facebookLoginBehavior"] || FBSDKLoginBehaviorSystemAccount;

	void (^handleLogin)(FBSDKLoginManagerLoginResult *result, NSError *error) = ^void(FBSDKLoginManagerLoginResult *result, NSError *error) {
		[self onLoginResult:result error:error];
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
			[self finishLogin:YES withError:nil];
		} else if (publishPermissionFound && readPermissionFound) {
			// Mix of permissions, not allowed
			permissionsAllowed = NO;
			NSError *err = [NSError errorWithCode:LRErrorCodeNativeFacebookLoginFailed description:@"Facebook login failed" failureReason:@"Your app can't ask for both read and write permissions"];
			[self finishLogin:NO withError:err];
		} else if (publishPermissionFound) {
			// Only publish permissions
			[login logInWithPublishPermissions:permissions fromViewController:controller handler:handleLogin];
		} else {
			// Only read permissions
			[login logInWithReadPermissions:permissions fromViewController:controller handler:handleLogin];
		}
	} else {
		// Initial log in, can only ask for read type permissions
		if ([self areAllPermissionsReadPermissions:permissions]) {
			[login logInWithReadPermissions:permissions fromViewController:controller handler:handleLogin];
		} else {
			permissionsAllowed = NO;
			NSError *err = [NSError errorWithCode:LRErrorCodeNativeFacebookLoginFailed description:@"Facebook login failed" failureReason:@"You can only ask for read permissions initially"];
			[self finishLogin:NO withError:err];
		}
	}

	if (!permissionsAllowed) {
		NSError *err = [NSError errorWithCode:LRErrorCodeNativeFacebookLoginFailed description:@"Facebook login failed" failureReason:@"You can only ask for read permissions initially"];
		[self finishLogin:NO withError:err];
	}
}

- (void) onLoginResult:(FBSDKLoginManagerLoginResult *) result
				 error:(NSError *)error {

	if (error) {
		[self finishLogin:NO withError:error];
	} else if (result.isCancelled) {
		NSError *error = [NSError errorWithCode:LRErrorCodeNativeFacebookLoginCancelled
									description:@"Facebook Login cancelled"
								  failureReason:@"Faceook native login is cancelled"];
		[self finishLogin:NO withError:error];
	} else {
		// all other cases are handled by the access token notification
		NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
		// Get loginradius access_token for facebook access_token
		[[LoginRadiusREST sharedInstance] callAPIEndpoint:@"api/v2/access_token/facebook" method:@"GET" params:@{@"key": [LoginRadiusSDK apiKey], @"fb_access_token" : accessToken} completionHandler:^(NSDictionary *data, NSError *error) {
			NSString *token = [data objectForKey:@"access_token"];
			[LoginRadiusUtilities lrSaveUserData:nil lrToken:token];
			[self finishLogin:YES withError:nil];
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

- (void)finishLogin:(BOOL)success withError:(NSError*)error {
	if (self.handler) {
		self.handler(success, error);
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
