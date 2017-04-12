//
//  LoginRadiusSocialLoginManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

/**
 Social Login Manager
 */
@interface LoginRadiusSocialLoginManager : NSObject

#pragma mark - Init

/**
 Initializer

 @return singleton instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Methods

/**
 Safari/WebVidew Login with the given provider

 @param provider provider name in small case (e.g facebook, twitter, google, linkedin, yahoo etc)
 @param controller view controller where social login take place should not be nil
 @param handler code block executed after completion
 */
-(void)loginWithProvider:(NSString*)provider
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler;

/**
 Native Facebook Login

 @param params dictionary of parameters
     These are the valid keys
     - facebookPermissions : should be an array of strings
     - facebookLoginBehavior : should be FBSDKLoginBehaviorNative / FBSDKLoginBehaviorBrowser / FBSDKLoginBehaviorSystemAccount / FBSDKLoginBehaviorWeb
        recommended approach is to use FBSDKLoginBehaviorNative
 @param controller view controller where social login take place should not be nil
 @param handler code block executed after completion
 */
-(void)nativeFacebookLoginWithPermissions:(NSDictionary*)params
							 inController:(UIViewController*)controller
						completionHandler:(LRServiceCompletionHandler)handler;

/**
 Native Twitter Login

 @param consumerKey Your Twitter app's Consumer Key
 @param consumerSecret Your Twitter app's Consumer Secret
 @param controller view controller where social login take place should not be nil
 @param handler code block executed after completion
 */
-(void)nativeTwitterWithConsumerKey:(NSString*)consumerKey
                     consumerSecret:(NSString*)consumerSecret
                       inController:(UIViewController*)controller
                  completionHandler:(LRServiceCompletionHandler)handler;


/**
 Native Google Login

 @param access_token Google Access Token
 @param handler code block executed after completion
 */
-(void)nativeGoogleLoginWithAccessToken:(NSString*)access_token
                      completionHandler:(LRServiceCompletionHandler)handler;

/**
    Log out the user
 */
- (void)logout;

#pragma mark - AppDelegate methods

/**
    App Launched Delegate method
 */

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

/**
 App Open URL Delegate method

 @return If LoginRadius can handle the url it return YES otherwise NO
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
