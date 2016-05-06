//
//  LRErrors.h
//  LRSDK
//
//  Created by Raviteja Ghanta on 05/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRErrorCode.h"

@interface LRErrors : NSObject

// User Registration Service
+ (NSError*)serviceCancelled:(NSString*)action;
+ (NSError*)userRegistraionFailed;
+ (NSError*)userLoginFailed;
+ (NSError*)userForgotPasswordFailed;
+ (NSError*)userEmailVerificationFailed;
+ (NSError*)userSocialLoginFailed;
+ (NSError*)userResetPasswordFailed;

// User Profile
+ (NSError*)tokenEmpty;
+ (NSError*)userProfieWithErrorCode:(NSString*)errorCode;
+ (NSError*)userProfileError;

// Social Login
+ (NSError *)socialLoginCancelled:(NSString*) provider;
+ (NSError *)socialLoginFailed:(NSString*) provider;

// Native Social Login
+ (NSError*)nativeTwitterLoginCancelled;
+ (NSError*)nativeTwitterLoginFailed;
+ (NSError*)nativeFacebookLoginCancelled;
+ (NSError*)nativeFacebookLoginFailedMixedPermissions;
+ (NSError*)nativeFacebookLoginFailed;

@end
