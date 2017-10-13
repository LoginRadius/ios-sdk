//
//  LoginRadiusTwitterLogin.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

/**
 *  Twitter native login
 */
@interface LoginRadiusTwitterLogin : NSObject

#pragma mark - Init

#pragma mark - Methods

/**
 *  Login
 *
 *  @param handler service completion handler
 */
- (void)getLRTokenWithTwitterToken:(NSString*)twitter_token
                        twitterSecret:(NSString*)twitter_secret
                       inController:(UIViewController *)controller
                        handler:(LRServiceCompletionHandler)handler;
@end
