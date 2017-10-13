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
@interface LoginRadiusManager : NSObject

#pragma mark - Init

/**
 Initializer

 @return singleton instance
 */
+ (instancetype)sharedInstance;

#pragma mark - Methods
/**
 Start registation service with action

 @param action should be one of these[@"login", @"registration", @"forgotpassword", @"social"]
 @param controller view controller where user registration actions take place should not be nil

 will post an event notification with [@"lr-login", @"lr-registration", @"lr-forgotpassword", @"lr-social"]
 */
- (void) registrationWithAction:(NSString*) action
				   inController:(UIViewController*)controller;


/**
 Safari/WebVidew Login with the given provider

 @param provider provider name in small case (e.g facebook, twitter, google, linkedin, yahoo etc)
 @param controller view controller where social login take place should not be nil
 */
-(void)loginWithProvider:(NSString*)provider
			inController:(UIViewController*)controller;

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

 @param twitterAccessToken Your Twitter User's Access Token
 @param twitterSecret Your Twitter app's Consumer Secret
 @param controller view controller where Twitter login take place should not be nil
 @param handler code block executed after completion
 */
- (void)convertTwitterTokenToLRToken:(NSString *)twitterAccessToken
                       twitterSecret:(NSString *)twitterSecret
                       inController:(UIViewController *)controller
                       completionHandler:(LRServiceCompletionHandler)handler;


/**
 Native Google Login

 @param google_token Google Access Token
 @param controller view controller where google login take place should not be nil
 @param handler code block executed after completion
 */
-(void)convertGoogleTokenToLRToken:(NSString*)google_token
                      inController:(UIViewController *)controller
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
