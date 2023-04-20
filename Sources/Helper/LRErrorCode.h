//
//  LRErrorCode.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#ifndef LRErrorCode_h
#define LRErrorCode_h

/**
 *  Registration Service, Social Login and API Response error code's.
 */
typedef NS_ENUM(NSInteger, LRErrorCode) {
    /**
     *  User Registration Service cancelled
     */
    LRErrorCodeRaaSCancelled,
    
    /**
     *  RaaS user registation failed
     */
    LRErrorCodeRaaSUserRegistrationFailed,
    
    /**
     *  RaaS user login failed
     */
    LRErrorCodeRaaSUserLoginFailed,
    
    /**
     *  RaaS user forgot password failed
     */
    LRErrorCodeRaaSUserForgotPasswordFailed,
    
    /**
     *  RaaS user email verification failed
     */
    LRErrorCodeRaaSUserEmailVerificationFailed,
    
    /**
     *  RaaS user social login failed
     */
    LRErrorCodeRaaSUserSocialLoginFailed,
    
    /**
     *  RaaS user reset password failed
     */
    
    LRErrorCodeRaaSUserResetPasswordFailed,
    
    /**
     *  Social Login cancelled
     */
    LRErrorCodeWebSocialLoginCancelled,
    
    /**
     *  Social Login failed
     */
    LRErrorCodeWebSocialLoginFailed,
  
    /**
     *  Native facebook login cancelled
     */
    LRErrorCodeNativeFacebookLoginCancelled,
    
    /**
     *  Native facebook login failed
     */
    LRErrorCodeNativeFacebookLoginFailed,

    /**
     *  Native twitter login cancelled
     */
    LRErrorCodeNativeTwitterLoginCancelled,

    /**
     *  Native twitter login not available
     */
    LRErrorCodeNativeTwitterLoginNotAvailable,

    /**
     *  Native twitter login failed
     */
    LRErrorCodeNativeTwitterLoginFailed,
    
    /**
     *  Access Token Invalid
     */
    LRErrorCodeAccessTokenInvalid,
    
    /**
     *  Access Token Empty
     */
    LRErrorCodeAccessTokenEmpty,
    
    /**
     *  user profile blocked,
     */
    LRErrorCodeUserProfileBlocked,
    /**
     *  user profile error
     */
    LRErrorCodeUserProfileError,
    /**
     *  TouchID error
     */
    LRErrorCodeTouchIDNotAvailable,
    /**
     *  User is not verified
     */
    /**
     * FaceID error
     */
    LRErrorCodeFaceIDNotAvailable,
    /**
     *  User is not verified
     */
    LRErrorCodeUserIsNotVerified,
    /**
     *  Failed to fetch social login list
     */
    LRErrorCodeWebSocialLoginFetchFailed,
    /**
     *  User profile have Required Fields as null
     */
    LRErrorCodeUserRequireAdditionalFieldsError

};

#endif /* LRErrorCode_h */
