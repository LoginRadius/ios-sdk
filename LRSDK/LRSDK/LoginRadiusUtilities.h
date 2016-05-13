//
//  LoginRadiusUtilities.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusUtilities.h"

/**
 *  Utilities Class
 */
@interface LoginRadiusUtilities : NSObject

#pragma mark - Class methods
/**
 *  save user profile with the given access token
 *
 *  @param userProfile userprofile dicitonary, if nil fetches the profile with the access token
 *  @param token       access token
 *
 *  @return YES if success, NO if user is blocked or any other error
 */

+ (BOOL)lrSaveUserData :(NSMutableDictionary *)userProfile lrToken:(NSString *)token;

/**
 *  Save RaaS user data
 *
 *  @param token access token
 *  @param key   API key
 *
 *  @return YES if success, NO if user is blocked or any other error
 */

+ (BOOL)lrSaveUserRaaSData :(NSString *)token APIKey:(NSString *)key;
@end