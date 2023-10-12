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
       completionHandler:(LRAPIResponseHandler)handler;



/**
 *  Native Facebook Login
 *
 *  @param params     dict of parameters
 These are the valid keys
 - facebookPermissions : should be an array of strings
 - facebookLoginBehavior : New FB SDK is supporting FBSDKLoginBehaviorBrowser only
 recommended approach is to use FBSDKLoginBehaviorSystemAccount
 *  @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. facebook_<social app name> )
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */
-(void)nativeFacebookLoginWithPermissions:(NSDictionary*)params
                            withSocialAppName:(NSString * _Nullable)socialAppName inController:(UIViewController*)controller
                        completionHandler:(LRAPIResponseHandler)handler;

/**
 Native Twitter Login
 
 @param twitterAccessToken Your Twitter User's Access Token
 @param twitterSecret Your Twitter app's Consumer Secret
 @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. twitter_<social app name> )
 @param controller view controller where Twitter login take place should not be nil
 @param handler code block executed after completion
 */
- (void)convertTwitterTokenToLRToken:(NSString *)twitterAccessToken
                       twitterSecret:(NSString *)twitterSecret
                   withSocialAppName:(NSString * _Nullable)socialAppName
                        inController:(UIViewController *)controller
                   completionHandler:(LRAPIResponseHandler)handler;

/**
 Native Google Login
 
 @param google_token Google Access Token
 @param google_refresh_token Google refresh_token
 @param google_client_id Google client_id
 @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. google_<social app name> )
 @param controller view controller where google login take place should not be nil
 @param handler code block executed after completion
 */
-(void)convertGoogleTokenToLRToken:(NSString*)google_token
              google_refresh_token:(NSString *)google_refresh_token
                  google_client_id:(NSString *)google_client_id
                 withSocialAppName:(NSString * _Nullable)socialAppName
                      inController:(UIViewController *)controller
                 completionHandler:(LRAPIResponseHandler)handler;



/**
 Native WeChat Login
 
 @param code WeChat Access Code
 @param handler code block executed after completion
 */
-(void)convertWeChatCodeToLRToken:(NSString*)code
                completionHandler:(LRAPIResponseHandler)handler;



/**
 Native Apple Login
 
 @param code Apple Access Code
 @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. apple_<social app name> )
 @param handler code block executed after completion
 */
-(void)convertAppleCodeToLRToken:(NSString*)code
               withSocialAppName:(NSString * _Nullable)socialAppName completionHandler:(LRAPIResponseHandler)handler;


/**
 *  Log out the user
 */
- (void)logout;

#pragma mark - AppDelegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

/**
 *  Call this for native social login to work properly
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString * _Nullable)sourceApplication annotation:(id _Nullable)annotation;

@end
