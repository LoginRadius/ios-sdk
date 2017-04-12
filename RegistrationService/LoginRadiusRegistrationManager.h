//
//  LoginRadiusRegistrationManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

/**
 Registration Service manager
 */
@interface LoginRadiusRegistrationManager : NSObject

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
 @param handler code block executed after completion
 */
- (void) registrationWithAction:(NSString*) action
				   inController:(UIViewController*)controller
			  completionHandler:(LRServiceCompletionHandler)handler;

#pragma mark - AppDelegate methods

/**
 App Launched Delegate method.
 */
- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

/**
 App Open URL Delegate method

 @return If LoginRadius can handle the url it return YES otherwise NO.
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
