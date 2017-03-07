//
//  LoginRadiusSocialLoginManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

/**
 *  Social Login Manager
 */
@interface LoginRadiusSocialLoginManager : NSObject

#pragma mark - Init

/**
 *  Initializer
 *  @return singleton instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Methods

/**
 *  Login with the given provider
 *
 *  @param provider   provider name in small case (e.g facebook, twitter, google, linkedin, yahoo etc)
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */
-(void)loginWithProvider:(NSString*)provider
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler;

/**
 *  Native Facebook Login
 *
 *  @param params     dict of parameters
 These are the valid keys
 - facebookPermissions : should be an array of strings
 - facebookLoginBehavior : should be FBSDKLoginBehaviorNative / FBSDKLoginBehaviorBrowser / FBSDKLoginBehaviorSystemAccount / FBSDKLoginBehaviorWeb
 recommended approach is to use FBSDKLoginBehaviorSystemAccount
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */
-(void)nativeFacebookLoginWithPermissions:(NSDictionary*)params
							 inController:(UIViewController*)controller
						completionHandler:(LRServiceCompletionHandler)handler;

-(void)nativeTwitterWithConsumerKey:(NSString*)consumerKey
                     consumerSecret:(NSString*)consumerSecret
                       inController:(UIViewController*)controller
                  completionHandler:(LRServiceCompletionHandler)handler;

-(void)nativeGoogleLoginWithAccessToken:(NSString*)access_token
                      completionHandler:(LRServiceCompletionHandler)handler;

/**
 *  Log out the user
 */
- (void)logout;

#pragma mark - AppDelegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

/**
 *  Call this for native social login to work properly
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
