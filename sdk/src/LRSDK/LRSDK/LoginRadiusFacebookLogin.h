//
//  LoginRadiusFacebookLogin.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

/**
 *  Facebook native login
 */
@interface LoginRadiusFacebookLogin : NSObject

#pragma mark - Init

/**
 *  Init
 *
 *  @return singleton instance
 */
+ (instancetype)sharedInstance;
+ (instancetype)instanceWithApplication:(UIApplication *)application
						  launchOptions:(NSDictionary *)launchOptions;

#pragma mark - Methods

/**
 *  Login
 *
 *  @param controller controller is needed for FB native login
 *  @param params     params should have the permissons array and login behaviour
 *  @param handler    serive completion handler
 */

- (void)loginfromViewController:(UIViewController*)controller
					 parameters:(NSDictionary*)params
						handler:(LRServiceCompletionHandler)handler;

/**
 *  Log out the user
 */
- (void)logout;


#pragma mark - AppDelegate methods
/**
 *  Call this for facebook login to work properly
 */
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation;

@end
