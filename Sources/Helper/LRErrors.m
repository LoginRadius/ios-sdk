//
//  LRErrors.m
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LRErrors.h"
#import "LoginRadiusError.h"

@implementation LRErrors

+ (NSError*)serviceCancelled:(NSString*)action {
	return [NSError errorWithCode:LRErrorCodeRaaSCancelled
					  description:@"User Registration Service cancelled"
					failureReason:[NSString stringWithFormat:@"User registration with action: %@ cancelled", action]];
}

+ (NSError*)userRegistraionFailed {
	return [NSError errorWithCode:LRErrorCodeRaaSUserRegistrationFailed
					  description:@"User registration failed"
					failureReason:@"User registration failed with no status"];
}

+ (NSError*)userLoginFailed {
	return [NSError errorWithCode:LRErrorCodeRaaSUserLoginFailed
					  description:@"User login failed"
					failureReason:@"User login failed since token not recieved"];
}

+ (NSError*)userForgotPasswordFailed {
	return  [NSError errorWithCode:LRErrorCodeRaaSUserForgotPasswordFailed
					   description:@"User forgot password failed"
					 failureReason:@"User forgot password failed with no status"];
}

+ (NSError*)userIsNotVerified:(NSString*)field {
	return  [NSError errorWithCode:LRErrorCodeUserIsNotVerified
					   description:[NSString stringWithFormat:@"User %@ is not verified", field]
					 failureReason:[NSString stringWithFormat:@"User need to verify %@ in order to proceed", field]];
}

+ (NSError*)userEmailVerificationFailed {
	return  [NSError errorWithCode:LRErrorCodeRaaSUserEmailVerificationFailed
					   description:@"User email verification failed"
					 failureReason:@"User email verification failed with no status"];
}

+ (NSError*)userSocialLoginFailed {
	return  [NSError errorWithCode:LRErrorCodeRaaSUserSocialLoginFailed
					   description:@"User social login failed"
					 failureReason:@"User social login failed since token not recieved"];
}

+ (NSError*)userResetPasswordFailed {
	return  [NSError errorWithCode:LRErrorCodeRaaSUserResetPasswordFailed
					   description:@"User reset password failed"
					 failureReason:@"User reset password failed failed with no status"];

}

+ (NSError*)tokenEmpty {
	return [NSError errorWithCode:LRErrorCodeAccessTokenEmpty
					  description:@"User profile fetching failed"
					failureReason:@"Access token is empty or null"];
}

+ (NSError*)userProfieWithErrorCode:(NSString*)errorCode {
	return [NSError errorWithCode:LRErrorCodeUserProfileError
					  description:@"User profile error"
					failureReason:[NSString stringWithFormat:@"User profile error with error code %@", errorCode]];
}

+ (NSError*)userProfileError {
	return [NSError errorWithCode:LRErrorCodeUserProfileError
			   description:@"User profile error"
			 failureReason:@"User profile is either bloked or returned with an errorCode"];
}

+ (NSError*)userProfileRequireAdditionalFields {
	return [NSError errorWithCode:LRErrorCodeUserRequireAdditionalFieldsError
			   description:@"User profile has incomplete required fields"
			 failureReason:@"User profile has null fields that are required before registration/loggin in"];
}

+ (NSError*)socialLoginFetchFailed {
	return [NSError errorWithCode:LRErrorCodeWebSocialLoginFetchFailed
					  description:@"Failed to fetch social login list"
					failureReason:@"Failed to fetch social login list from server"];
}

+ (NSError*)socialLoginCancelled:(NSString*) provider {
	return [NSError errorWithCode:LRErrorCodeWebSocialLoginCancelled
					  description:@"Social Login cancelled"
					failureReason:[NSString stringWithFormat:@"Social login with %@ is cancelled", provider]];
}

+ (NSError*)socialLoginFailed:(NSString*) provider {
	return [NSError errorWithCode:LRErrorCodeWebSocialLoginFailed
								description:@"Social Login failed"
							  failureReason:[NSString stringWithFormat:@"Social login with %@ is failed since token is not recieved", provider]];
}

+ (NSError*)nativeTwitterLoginNoAccount {
    return [NSError errorWithCode:LRErrorCodeNativeTwitterLoginCancelled
                      description:@"Twitter login not available"
                    failureReason:@"Native Twitter login is not available since user doesn't have a configured twitter account"];
}

+ (NSError*)nativeTwitterLoginCancelled {
	return [NSError errorWithCode:LRErrorCodeNativeTwitterLoginNotAvailable
					  description:@"Twitter login cancelled"
					failureReason:@"Native twitter login is cancelled by user"];
}

+ (NSError*)nativeTwitterLoginFailed {
	return [NSError errorWithCode:LRErrorCodeNativeTwitterLoginFailed
					  description:@"Twitter login failed"
					failureReason:@"Native twitter login is not granted by user"];
}

+ (NSError*)nativeFacebookLoginCancelled {
	return [NSError errorWithCode:LRErrorCodeNativeFacebookLoginCancelled
					  description:@"Facebook Login cancelled"
					failureReason:@"Faceook native login is cancelled"];

}

+ (NSError*)nativeFacebookLoginFailed {
	return [NSError errorWithCode:LRErrorCodeNativeFacebookLoginFailed 
					  description:@"Facebook login failed"
					failureReason:@"Your app should only ask for read permissions for first time login"];
}

+ (NSError*)nativeFacebookLoginFailedMixedPermissions {
	return [NSError errorWithCode:LRErrorCodeNativeFacebookLoginFailed
					  description:@"Facebook login failed"
					failureReason:@"Your app can't ask for both read and write permissions"];
}

+ (NSError*)touchIDNotAvailable {
    return [NSError errorWithCode:LRErrorCodeTouchIDNotAvailable
                      description:@"Touch ID authentication failed"
                    failureReason:@"The User's device cannot be authenticated using TouchID"];
}

+ (NSError*)touchIDNotDeviceOwner {
    return [NSError errorWithCode:LRErrorCodeTouchIDNotAvailable
                      description:@"Touch ID authentication failed"
                    failureReason:@"TouchID Authentiction failed since the user is not the device's owner"];
}

+ (NSError*)faceIDNotAvailable {
    return [NSError errorWithCode:LRErrorCodeFaceIDNotAvailable
                      description:@"Face ID authentication failed"
                    failureReason:@"The User's device cannot be authenticated using FaceID"];
}

+ (NSError*)faceIDNotDeviceOwner {
    return [NSError errorWithCode:LRErrorCodeFaceIDNotAvailable
                      description:@"Face ID authentication failed"
                    failureReason:@"FaceID Authentiction failed since the user is not the device's owner"];
}
@end
