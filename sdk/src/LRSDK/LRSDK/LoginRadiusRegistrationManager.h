//
//  LoginRadiusRegistrationManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

/**
 *  Registration Service manager
 */
@interface LoginRadiusRegistrationManager : NSObject

#pragma mark - Init
/**
 *  Initializer
 *  @return singleton instance
 */
+ (instancetype)instanceWithApplication:(UIApplication*)application launchOptions:(NSDictionary*)launchOptions;
+ (instancetype)sharedInstance;

#pragma mark - Methods
/**
 *  Start registation service with action
 *
 *  @param action     should be one of these[@"login", @"registration", @"forgotpassword", @"social"]
 *  @param controller view controller where user registration actions take place should not be nil
 *  @param handler    code block executed after completion
 */
- (void) registrationWithAction:(NSString*) action
				   inController:(UIViewController*)controller
			  completionHandler:(LRServiceCompletionHandler)handler;

@end
