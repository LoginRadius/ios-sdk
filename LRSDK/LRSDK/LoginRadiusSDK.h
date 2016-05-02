//
//  LoginRadiusSDK.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSError+LRError.h"
#import "LRErrorCode.h"

typedef void (^LRAPIResponseHandler)(NSDictionary *data, NSError *error);
typedef void (^LRServiceCompletionHandler)(BOOL success, NSError *error);

@interface LoginRadiusSDK : NSObject

// Default value is false, set this to true to use native social login
@property (nonatomic) BOOL useNativeSocialLogin;

// Initilization, this should be the first function that should be called before any other.
+ (void)instanceWithAPIKey:(NSString *)apiKey
				  siteName:(NSString *)siteName
			   application:(UIApplication *)application
			 launchOptions:(NSDictionary *)launchOptions;

+ (instancetype)sharedInstance;

// Application Delegate methods
- (BOOL)application:(UIApplication *)application
		   openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
		annotation:(id)annotation;

- (void)applicationDidBecomeActive:(UIApplication *)application;

/*
	Social Login with the provider
	@param provider - provider name
	@param parameters - dict of parameters
			These are the valid keys
			- facebookPermissions : should be an array of strings
			- facebookLoginBehavior : should be FBSDKLoginBehaviorNative / FBSDKLoginBehaviorBrowser / FBSDKLoginBehaviorSystemAccount / FBSDKLoginBehaviorWeb
				recommended approach is to use FBSDKLoginBehaviorSystemAccount
	@param controller - view controller where social login take place should not be nil
	@param handler - code block executed after completion
 
	@note Params are only valid when native login is configured, otherwise the settings configured in the user account
		are taken
 */

+ (void) socialLoginWithProvider:(NSString*)provider
					  parameters:(NSDictionary*)opts
					inController:(UIViewController*)controller
			   completionHandler:(LRServiceCompletionHandler)handler;

/*
	User Registration with the action 
	@param action - user registration action should be one of these @"login", @"registration", @"forgotpassword", @"sociallogin", @"resetpassword", @"emailverification"
	@param controller - view controller where user registration actions take place should not be nil
	@param handler - code block executed after completion
 */
+ (void) userRegistrationWithAction:(NSString*) action
					   inController:(UIViewController*)controller
				  completionHandler:(LRServiceCompletionHandler)handler;

/*
	Logouts the user
 */

+ (void) logout;

+ (NSString*) apiKey;
+ (NSString*) siteName;

@end
