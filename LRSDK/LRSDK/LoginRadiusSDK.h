//
//  LoginRadiusSDK.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LRAPIResponseHandler)(NSDictionary *data, NSError *error);
typedef void (^LRServiceCompletionHandler)(BOOL success, NSError *error);

/**
 *  This class is the entry point for all loginradius functionality
 */
@interface LoginRadiusSDK : NSObject

#pragma mark - Properties

/**
 * Default value is false, set this to true to use native social login
 * Right now only facebook and twitter native login are supported
 */
@property (nonatomic) BOOL useNativeSocialLogin;

#pragma mark - Initilizers
/**
 *  Initilization, this should be the first function that should be called before any other call to LoginRadiusSDK.
 *
 *  @param apiKey        LoginRadius API Key
 *  @param siteName      LoginRadius Site name
 *  @param application   application from appdelegate
 *  @param launchOptions launchOptions from appdelegate
 */
+ (void)instanceWithAPIKey:(NSString *)apiKey
				  siteName:(NSString *)siteName
			   application:(UIApplication *)application
			 launchOptions:(NSDictionary *)launchOptions;

/**
 *  LoginRadiusSDK singleton
 *
 *  @return LoginRadius singleton object
 */
+ (instancetype)sharedInstance;

#pragma mark - Application Delegate methods

/** Application Delegate methods
 */
- (BOOL)application:(UIApplication *)application
		   openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
		annotation:(id)annotation;

/** Application Delegate methods
 */
- (void)applicationDidBecomeActive:(UIApplication *)application;


#pragma mark - Social Login
/**
 *  Social Login with the provider
 *
 *  @param provider   provider name
 *  @param opts       dict of parameters
                        These are the valid keys
                            - facebookPermissions : should be an array of strings
                            - facebookLoginBehavior : should be FBSDKLoginBehaviorNative / FBSDKLoginBehaviorBrowser / FBSDKLoginBehaviorSystemAccount / FBSDKLoginBehaviorWeb
                            recommended approach is to use FBSDKLoginBehaviorSystemAccount
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */
+ (void) socialLoginWithProvider:(NSString*)provider
					  parameters:(NSDictionary*)opts
					inController:(UIViewController*)controller
			   completionHandler:(LRServiceCompletionHandler)handler;

#pragma mark - Registration Service
/**
 *  Registration Service with the action
 *
 *  @param action     user registration action should be one of these @"login", @"registration", @"forgotpassword", @"sociallogin", @"resetpassword", @"emailverification"
 *  @param controller view controller where user registration actions take place should not be nil
 *  @param handler    code block executed after completion
 */
+ (void) registrationServiceWithAction:(NSString*) action
						  inController:(UIViewController*)controller
					 completionHandler:(LRServiceCompletionHandler)handler;

#pragma mark - Logout
/**
 *  Log out the user
 */
+ (void) logout;

#pragma mark - API Key and Sitename
/**
 *  LoginRadius API key
 *
 *  @return LoginRadius API key
 */
+ (NSString*) apiKey;

/**
 *  LoginRadius Sitename
 *
 *  @return LoginRadius Sitename
 */
+ (NSString*) siteName;

@end
