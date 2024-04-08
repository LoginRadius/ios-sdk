//
//  LRErrors.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public class LRErrors {
    public static func serviceCancelled(action: String) -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSCancelled.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User Registration Service cancelled",
                NSLocalizedFailureReasonErrorKey: "User registration with action: \(action) cancelled"
            ]
        )
    }
    
    public static func userRegistraionFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSUserRegistrationFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User registration failed",
                NSLocalizedFailureReasonErrorKey: "User registration failed with no status"
            ]
        )
    }
    
    public static func userLoginFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSUserLoginFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User login failed",
                NSLocalizedFailureReasonErrorKey: "User login failed since token not received"
            ]
        )
    }
    
    public static func userForgotPasswordFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSUserForgotPasswordFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User forgot password failed",
                NSLocalizedFailureReasonErrorKey: "User forgot password failed with no status"
            ]
        )
    }
    
    public static func userIsNotVerified(field: String) -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.UserIsNotVerified.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User \(field) is not verified",
                NSLocalizedFailureReasonErrorKey: "User need to verify \(field) in order to proceed"
            ]
        )
    }
    
    public static func userEmailVerificationFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSUserEmailVerificationFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User email verification failed",
                NSLocalizedFailureReasonErrorKey: "User email verification failed with no status"
            ]
        )
    }
    
    public static func userSocialLoginFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSUserSocialLoginFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User social login failed",
                NSLocalizedFailureReasonErrorKey: "User social login failed since token not received"
            ]
        )
    }
    
    public static func userResetPasswordFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.RaaSUserResetPasswordFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User reset password failed",
                NSLocalizedFailureReasonErrorKey: "User reset password failed with no status"
            ]
        )
    }
    
    public static func tokenEmpty() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.AccessTokenEmpty.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User profile fetching failed",
                NSLocalizedFailureReasonErrorKey: "Access token is empty or null"
            ]
        )
    }
    
    public static func userProfieWithErrorCode(errorCode: String) -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.UserProfileError.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User profile error",
                NSLocalizedFailureReasonErrorKey: "User profile error with error code \(errorCode)"
            ]
        )
    }
    
    public static func userProfileError() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.UserProfileError.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User profile error",
                NSLocalizedFailureReasonErrorKey: "User profile is either blocked or returned with an errorCode"
            ]
        )
    }
    
    public static func userProfileRequireAdditionalFields() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.UserRequireAdditionalFieldsError.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "User profile has incomplete required fields",
                NSLocalizedFailureReasonErrorKey: "User profile has null fields that are required before registration/logging in"
            ]
        )
    }
    
    public static func socialLoginFetchFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.WebSocialLoginFetchFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Failed to fetch social login list",
                NSLocalizedFailureReasonErrorKey: "Failed to fetch social login list from the server"
            ]
        )
    }
    
    public static func socialLoginCancelled(provider: String) -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.WebSocialLoginCancelled.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Social Login cancelled",
                NSLocalizedFailureReasonErrorKey: "Social login with \(provider) is cancelled"
            ]
        )
    }
    
    public static func socialLoginFailed(provider: String) -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.WebSocialLoginFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Social Login failed",
                NSLocalizedFailureReasonErrorKey: "Social login with \(provider) is failed since the token is not received"
            ]
        )
    }
    
    public static func nativeTwitterLoginNoAccount() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.NativeTwitterLoginCancelled.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Twitter login not available",
                NSLocalizedFailureReasonErrorKey: "Native Twitter login is not available since the user doesn't have a configured Twitter account"
            ]
        )
    }
    
    public static func nativeTwitterLoginCancelled() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.NativeTwitterLoginNotAvailable.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Twitter login cancelled",
                NSLocalizedFailureReasonErrorKey: "Native Twitter login is cancelled by the user"
            ]
        )
    }
    
    public static func nativeTwitterLoginFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.NativeTwitterLoginFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Twitter login failed",
                NSLocalizedFailureReasonErrorKey: "Native Twitter login is not granted by the user"
            ]
        )
    }
    
    public static func nativeFacebookLoginCancelled() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.NativeFacebookLoginCancelled.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Facebook Login cancelled",
                NSLocalizedFailureReasonErrorKey: "Facebook native login is cancelled"
            ]
        )
    }
    
    public static func nativeFacebookLoginFailed() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.NativeFacebookLoginFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Facebook login failed",
                NSLocalizedFailureReasonErrorKey: "Your app should only ask for read permissions for first-time login"
            ]
        )
    }
    
    public static func nativeFacebookLoginFailedMixedPermissions() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.NativeFacebookLoginFailed.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Facebook login failed",
                NSLocalizedFailureReasonErrorKey: "Your app can't ask for both read and write permissions"
            ]
        )
    }
    
    public static func touchIDNotAvailable() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.TouchIDNotAvailable.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Touch ID authentication failed",
                NSLocalizedFailureReasonErrorKey: "The user's device cannot be authenticated using TouchID"
            ]
        )
    }
    
    public static func touchIDNotDeviceOwner() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.TouchIDNotAvailable.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Touch ID authentication failed",
                NSLocalizedFailureReasonErrorKey: "TouchID authentication failed since the user is not the device's owner"
            ]
        )
    }
    
    public static func faceIDNotAvailable() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.FaceIDNotAvailable.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Face ID authentication failed",
                NSLocalizedFailureReasonErrorKey: "The user's device cannot be authenticated using FaceID"
            ]
        )
    }
    
    public static func faceIDNotDeviceOwner() -> NSError {
        return NSError(
            domain: "LoginRadiusErrorDomain",
            code: LRErrorCode.FaceIDNotAvailable.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: "Face ID authentication failed",
                NSLocalizedFailureReasonErrorKey: "FaceID authentication failed since the user is not the device's owner"
            ]
        )
    }
}

