//
//  LoginRadiusGoogleLogin.h
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"
/**
 *  Google native login
 */
@interface LoginRadiusGoogleLogin : NSObject

#pragma mark - Init

#pragma mark - Methods

/**
 *  Login
 *
 *  @param google_token google's access token
 *  @param handler    serive completion handler
 */

- (void)convertGoogleTokenToLRToken :(NSString*)google_token
                            inController:(UIViewController *)controller
                                 handler:(LRServiceCompletionHandler) handler;


@end
