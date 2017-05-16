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
-(void)loginWithConsumerKey:(NSString*)consumerKey
           andConumerSecret:(NSString*)consumerSecret
               inController:(UIViewController*)controller
                 completion:(LRServiceCompletionHandler)handler;
@end
