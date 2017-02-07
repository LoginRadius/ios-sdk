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

#pragma mark - Properties

/**
 *  set this to YES for native social login
 */
@property BOOL useNativeLogin;

#pragma mark - Init

/**
 *  Initializer
 *  @return singleton instance
 */
+ (instancetype)instanceWithApplication:(UIApplication*)application launchOptions:(NSDictionary*)launchOptions;
+ (instancetype)sharedInstance;

#pragma mark - Methods

/**
 *  Login with the given provider
 *
 *  @param provider   provider name in small case (e.g facebook, twitter, google, linkedin, yahoo etc)
 *  @param params     dict of parameters
                            These are the valid keys
                            - facebookPermissions : should be an array of strings
                            - facebookLoginBehavior : should be FBSDKLoginBehaviorNative / FBSDKLoginBehaviorBrowser / FBSDKLoginBehaviorSystemAccount / FBSDKLoginBehaviorWeb
                            recommended approach is to use FBSDKLoginBehaviorSystemAccount
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */
-(void)loginWithProvider:(NSString*)provider
			  parameters:(NSDictionary*)params
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler;

/**
 *  Log out the user
 */
- (void)logout;

#pragma mark - AppDelegate methods

/**
 *  Call this for native social login to work properly
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
