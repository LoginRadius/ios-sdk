//
//  LRErrors.h
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRErrorCode.h"
/**
 *  Wrapper class for error objects
 */
@interface LRErrors : NSObject

#pragma mark - User Registration Service
+ (NSError*)serviceCancelled:(NSString*)action;
+ (NSError*)userRegistraionFailed;
+ (NSError*)userLoginFailed;
+ (NSError*)userForgotPasswordFailed;
+ (NSError*)userIsNotVerified:(NSString*)field;
+ (NSError*)userEmailVerificationFailed;
+ (NSError*)userSocialLoginFailed;
+ (NSError*)userResetPasswordFailed;

#pragma mark - User profile
+ (NSError*)tokenEmpty;
+ (NSError*)userProfieWithErrorCode:(NSString*)errorCode;
+ (NSError*)userProfileError;
+ (NSError*)userProfileRequireAdditionalFields;

#pragma mark - Social Login
+ (NSError *)socialLoginFetchFailed;
+ (NSError *)socialLoginCancelled:(NSString*) provider;
+ (NSError *)socialLoginFailed:(NSString*) provider;

#pragma mark - Native Social Login
+ (NSError*)nativeTwitterLoginNoAccount;
+ (NSError*)nativeTwitterLoginCancelled;
+ (NSError*)nativeTwitterLoginFailed;
+ (NSError*)nativeFacebookLoginCancelled;
+ (NSError*)nativeFacebookLoginFailedMixedPermissions;
+ (NSError*)nativeFacebookLoginFailed;

#pragma mark - Touch ID
+ (NSError*)touchIDNotAvailable;
+ (NSError*)touchIDNotDeviceOwner;

#pragma mark - Face ID
+ (NSError*)faceIDNotAvailable;
+ (NSError*)faceIDNotDeviceOwner;

@end
