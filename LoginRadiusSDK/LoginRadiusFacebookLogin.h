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

#pragma mark - Methods

/**
 *  Login
 *
 *  @param controller controller is needed for FB native login
 *  @param params    params should have the permissons array and login behaviour
 *  @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. facebook_<social app name> )
 *  @param handler    service completion handler
 */

- (void)loginfromViewController:(UIViewController*)controller
                     parameters:(NSDictionary*)params
 withSocialAppName:(NSString * _Nullable)socialAppName
                        handler:(LRAPIResponseHandler)handler;

/**
 *  Log out the user
 */
- (void)logout;


#pragma mark - AppDelegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

/**
 *  Call this for facebook login to work properly
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString * _Nullable)sourceApplication
         annotation:(id _Nullable)annotation;

@end
