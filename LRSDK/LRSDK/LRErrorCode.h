//
//  LRErrorCode.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#ifndef LRErrorCode_h
#define LRErrorCode_h

typedef NS_ENUM(NSInteger, LRErrorCode) {
	// User Registration Service cancelled
	LRErrorCodeRaaSCancelled = 0,

	// RaaS user registation failed
	LRErrorCodeRaaSUserRegistrationFailed,

	// RaaS user login failed
	LRErrorCodeRaaSUserLoginFailed,

	// RaaS user forgot password failed
	LRErrorCodeRaaSUserForgotPasswordFailed,

	// RaaS user email verification failed
	LRErrorCodeRaaSUserEmailVerificationFailed,

	// RaaS user social login failed
	LRErrorCodeRaaSUserSocialLoginFailed,

	// RaaS user reset password failed
	LRErrorCodeRaaSUserResetPasswordFailed,

	// Social Login cancelled
	LRErrorCodeWebSocialLoginCancelled,

	// Social Login failed
	LRErrorCodeWebSocialLoginFailed,

	// Native facebook login cancelled
	LRErrorCodeNativeFacebookLoginCancelled,

	// Native facebook login failed
	LRErrorCodeNativeFacebookLoginFailed,

	// Native twitter login cancelled
	LRErrorCodeNativeTwiiterLoginCancelled,

	// Native twitter login failed
	LRErrorCodeNativeTwiiterLoginFailed,

	// Access Token Invalid
	LRErrorCodeAccessTokenInvalid,

	// Access Token Empty
	LRErrorCodeAccessTokenEmpty,


	// user profile blocked,
	LRErrorCodeUserProfileBlocked,

	LRErrorCodeUserProfileError
};


#endif /* LRErrorCode_h */
