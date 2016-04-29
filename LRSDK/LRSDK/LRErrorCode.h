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
	LRErrorCodeNativeTwiiterLoginFailed
};


#endif /* LRErrorCode_h */
