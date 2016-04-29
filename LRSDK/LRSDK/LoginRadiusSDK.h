//
//  LoginRadiusSDK.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSError+LRError.h"
#import "LRErrorCode.h"

typedef void (^responseHandler)(NSDictionary *data, NSError *error);
typedef void (^LRRaaSCompletionHandler)(BOOL success, NSError *error);

@interface LoginRadiusSDK : NSObject

// Initilization
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
 */

+ (void) socialLoginWithProvider:(NSString*)provider
					  parameters:(NSDictionary*)opts
					inController:(UIViewController*)controller
			   completionHandler:(responseHandler)handler;

/*
	User Registration with the action 
	@param action - user registration action should be one of these @"login", @"registration", @"forgotpassword", @"sociallogin", @"resetpassword", @"emailverification"
	@param controller - view controller where user registration actions take place should not be nil
	@param handler - code block executed after completion
 */
+ (void) userRegistrationWithAction:(NSString*) action
					   inController:(UIViewController*)controller
				  completionHandler:(LRRaaSCompletionHandler)handler;

/*
	Logouts the user
 */

+ (void) logout;

+ (NSString*) apiKey;
+ (NSString*) siteName;

@end
