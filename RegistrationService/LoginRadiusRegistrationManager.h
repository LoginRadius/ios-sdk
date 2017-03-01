//
//  LoginRadiusRegistrationManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

/**
 *  Registration Service manager
 */
@interface LoginRadiusRegistrationManager : NSObject

#pragma mark - Init
/**
 *  Initializer
 *  @return singleton instance
 */

+ (instancetype)sharedInstance;

#pragma mark - Methods

- (void)authAddEmail:(NSString *)email
           emailType:(NSString *)emailType
         accessToken:(NSString *)accessToken
     verificationUrl:(NSString *)verificationUrl
       emailTemplate:(NSString *)emailTemplate
   completionHandler:(LRAPIResponseHandler)completion;

// Forgot Password
- (void)authForgotPasswordWithEmail:(NSString *)email
				   resetPasswordUrl:(NSString *)resetPasswordUrl
					  emailTemplate:(NSString *)emailTemplate
				  completionHandler:(LRAPIResponseHandler)completion;

// Register User
- (void)authRegistrationWithEmails:(NSArray *)emails
					  withPassword:(NSString *)password
                          withSott:(NSString*)sott
				   verificationUrl:(NSString *)verificationUrl
					 emailTemplate:(NSString *)emailTemplate
				 completionHandler:(LRAPIResponseHandler)completion;

- (void)authCheckEmailAvailability:(NSString*)email
				 completionHandler:(LRAPIResponseHandler)completion;

- (void)authUserNameAvailability:(NSString*)email
			   completionHandler:(LRAPIResponseHandler)completion;

- (void)authLoginWithEmail:(NSString*)email
			  withPassword:(NSString*)password
				  loginUrl:(NSString*)loginUrl
		   verificationUrl:(NSString*)verificationUrl
			 emailTemplate:(NSString*)emailTemplate
		 completionHandler:(LRAPIResponseHandler)completion;

- (void)authLoginWithUserName:(NSString*)userName
				 withPassword:(NSString*)password
					 loginUrl:(NSString*)loginUrl
			  verificationUrl:(NSString*)verificationUrl
				emailTemplate:(NSString*)emailTemplate
			completionHandler:(LRAPIResponseHandler)completion;

- (void)authProfilesByToken:(NSString*)accessToken
		  completionHandler:(LRAPIResponseHandler)completion;

- (void)authSocialIdentity:(NSString*)accessToken
			 emailTemplate:(NSString*)emailTemplate
		 completionHandler:(LRAPIResponseHandler)completion;

- (void)authVerifyEmailWithToken:(NSString*)verificationtoken
							 url:(NSString*)url
			   completionHandler:(LRAPIResponseHandler)completion;

- (void)authChangePasswordWithAcessToken:(NSString*)accessToken
							 oldPassword:(NSString*)oldPassword
							 newPassword:(NSString*)newPassword
					   completionHandler:(LRAPIResponseHandler)completion;

- (void)authLinkSocialIdentityWithAcessToken:(NSString*)accessToken
							  candidateToken:(NSString*)candidateToken
						   completionHandler:(LRAPIResponseHandler)completion;

- (void)authResendEmailVerification:(NSString*)email
					  emailTemplate:(NSString*)emailTemplate
					verificationUrl:(NSString*)verificationUrl
				  completionHandler:(LRAPIResponseHandler)completion;

- (void)authResetPasswordWithResetToken:(NSString*)resetToken
							   password:(NSString*)password
					  completionHandler:(LRAPIResponseHandler)completion;

- (void)authResetPasswordWithSecurityQuestion:(NSDictionary*)securityQuestion
									   userid:(NSString*)userid // if phone no login then phone no and if email login then email id
									 password:(NSString*)password
							completionHandler:(LRAPIResponseHandler)completion;

- (void)authResetSetUserName:(NSString*)accessToken
					username:(NSString*)username
		   completionHandler:(LRAPIResponseHandler)completion;

- (void)authUpdateProfilebyToken:(NSString*)accessToken
				 verificationUrl:(NSString*)verificationUrl
				   emailTemplate:(NSString*)emailTemplate
						userData:(NSDictionary*)userData
			   completionHandler:(LRAPIResponseHandler)completion;

- (void)authUpdateSecurityQuestionWithAccessToken:(NSString*)accessToken
								 securityQuestion:(NSDictionary*)securityQuestion
								completionHandler:(LRAPIResponseHandler)completion;

- (void)authDeleteAccountWithToken:(NSString*)accessToken
				   verificationUrl:(NSString*)verificationUrl
					 emailTemplate:(NSString*)emailTemplate
				 completionHandler:(LRAPIResponseHandler)completion;

- (void)authDeleteEmailWithToken:(NSString*)accessToken
						   email:(NSString*)email
			   completionHandler:(LRAPIResponseHandler)completion;

- (void)authUnlinkSocialIdentityWithToken:(NSString*)accessToken
								 provider:(NSString*)provider
							   providerID:(NSString*)providerID
						completionHandler:(LRAPIResponseHandler)completion;

// Custom Object API

- (void)createCustomObjectWithAccessToken:(NSString*)token
                        customObjectName:(NSString*)objectName
                        customObjectData:(NSDictionary*)data
                       completionHandler:(LRAPIResponseHandler)completion;

- (void)getCustomObjectWithAccessToken:(NSString*)token
                  customObjectRecordID:(NSString*)objectRecordID
                      customObjectName:(NSString*)objectName
                     completionHandler:(LRAPIResponseHandler)completion;

- (void)getCustomObjectWithAccessToken:(NSString*)token
                      customObjectName:(NSString*)objectName
                     completionHandler:(LRAPIResponseHandler)completion;

- (void)updateCustomObjectWithToken:(NSString*)accessToken
               customObjectRecordID:(NSString*)objectRecordID
                   customObjectName:(NSString*)objectName
                   customObjectDate:(NSDictionary*)data
                  completionHandler:(LRAPIResponseHandler)completion;

- (void)DeleteCustomObjectWithToken:(NSString*)accessToken
               customObjectRecordID:(NSString*)objectRecordID
                   customObjectName:(NSString*)objectName
                   customObjectDate:(NSDictionary*)data
                  completionHandler:(LRAPIResponseHandler)completion;

#pragma mark - AppDelegate methods

- (BOOL)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

/**
 *  Call this for native social login to work properly
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
