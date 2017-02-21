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
-(void)login:(LRServiceCompletionHandler)handler;
@end
