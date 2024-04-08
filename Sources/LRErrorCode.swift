//
//  LRErrorCode.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

/**
 *  Registration Service, Social Login and API Response error code's.
 */
public enum LRErrorCode: Int {
    /**
     *  User Registration Service cancelled
     */
    case RaaSCancelled
    
    /**
     *  RaaS user registation failed
     */
    case RaaSUserRegistrationFailed
    
    /**
     *  RaaS user login failed
     */
    case RaaSUserLoginFailed
    
    /**
     *  RaaS user forgot password failed
     */
    case RaaSUserForgotPasswordFailed
    
    /**
     *  RaaS user email verification failed
     */
    case RaaSUserEmailVerificationFailed
    
    /**
     *  RaaS user social login failed
     */
    case RaaSUserSocialLoginFailed
    
    /**
     *  RaaS user reset password failed
     */
    case RaaSUserResetPasswordFailed
    
    /**
     *  Social Login cancelled
     */
    case WebSocialLoginCancelled
    
    /**
     *  Social Login failed
     */
    case WebSocialLoginFailed
    
    /**
     *  Native facebook login cancelled
     */
    case NativeFacebookLoginCancelled
    
    /**
     *  Native facebook login failed
     */
    case NativeFacebookLoginFailed
    
    /**
     *  Native twitter login cancelled
     */
    case NativeTwitterLoginCancelled
    
    /**
     *  Native twitter login not available
     */
    case NativeTwitterLoginNotAvailable
    
    /**
     *  Native twitter login failed
     */
    case NativeTwitterLoginFailed
    
    /**
     *  Access Token Invalid
     */
    case AccessTokenInvalid
    
    /**
     *  Access Token Empty
     */
    case AccessTokenEmpty
    
    /**
     *  user profile blocked,
     */
    case UserProfileBlocked
    
    /**
     *  user profile error
     */
    case UserProfileError
    
    /**
     *  TouchID error
     */
    case TouchIDNotAvailable
    
    /**
     *  User is not verified
     */
    /**
     * FaceID error
     */
    case FaceIDNotAvailable
    
    /**
     *  User is not verified
     */
    case UserIsNotVerified
    
    /**
     *  Failed to fetch social login list
     */
    case WebSocialLoginFetchFailed
    
    /**
     *  User profile have Required Fields as null
     */
    case UserRequireAdditionalFieldsError
}

