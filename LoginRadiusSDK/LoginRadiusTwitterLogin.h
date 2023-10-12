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
 *  @param twitter_token access token from Twitter
 *  @param twitter_secret secret from Twitter
 *  @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. twitter_<social app name> )
 *  @param controller controller is needed for Twitter native login
 *  @param handler service completion handler
 */
- (void)getLRTokenWithTwitterToken:(NSString*)twitter_token
                        twitterSecret:(NSString*)twitter_secret
                        withSocialAppName:(NSString * _Nullable)socialAppName
                       inController:(UIViewController *)controller
                        handler:(LRAPIResponseHandler)handler;
@end
