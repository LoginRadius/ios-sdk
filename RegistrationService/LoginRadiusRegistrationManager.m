//
//  LoginRadiusRegistrationManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRegistrationManager.h"
#import "LoginRadiusREST.h"
#import "LRSession.h"

@implementation LoginRadiusRegistrationManager

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusRegistrationManager *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusRegistrationManager alloc] init];
	});

	return instance;
}

- (void)authAddEmail:(NSString *)email
		   emailType:(NSString *)emailType
		 accessToken:(NSString *)accessToken
	 verificationUrl:(NSString *)verificationUrl
	   emailTemplate:(NSString *)emailTemplate
   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPOST:@"identity/v2/auth/email"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"verificationUrl": verificationUrl,
												 @"emailTemplate": emailTemplate
												 }
										  body:@{
												 @"Type": emailType,
												 @"Email": email
												 }
                             completionHandler:completion];
}

- (void)authForgotPasswordWithEmail:(NSString *)email
				   resetPasswordUrl:(NSString *)resetPasswordUrl
					  emailTemplate:(NSString *)emailTemplate
				  completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPOST:@"identity/v2/auth/password"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"resetPasswordUrl": resetPasswordUrl,
												 @"emailTemplate": emailTemplate
												 }
										  body:@{
												 @"email": email
												 }
                             completionHandler:completion];
}
- (void)authRegistrationWithData:(NSDictionary *)data
                        withSott:(NSString *)sott
                 verificationUrl:(NSString *)verificationUrl
                   emailTemplate:(NSString *)emailTemplate
               completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPOST:@"identity/v2/auth/register"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"sott": sott,
												 @"verificationUrl": verificationUrl,
												 @"emailTemplate": emailTemplate
												 }
										  body: data
                             completionHandler:completion];
}

- (void)authCheckEmailAvailability:(NSString*)email
				 completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/email"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"email": email
												}
                            completionHandler:completion];
}

- (void)authUserNameAvailability:(NSString*)email
			   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/username"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"email": email
												}
                            completionHandler:completion];
}


- (void)authLoginWithEmail:(NSString*)email
			  withPassword:(NSString*)password
				  loginUrl:(NSString*)loginUrl
		   verificationUrl:(NSString*)verificationUrl
			 emailTemplate:(NSString*)emailTemplate
		 completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/login"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"email": email,
												@"password": password,
												@"loginUrl": loginUrl,
												@"verificationUrl": verificationUrl,
												@"emailTemplate": emailTemplate
												}
							completionHandler:^(NSDictionary *data, NSError *error) {
                                if (error) {
                                    completion(nil, error);
                                } else {
                                    LRSession *session = [[LRSession alloc] initWithAccessToken:data[@"access_token"] userProfile:data[@"Profile"]];
                                    completion(session.userProfile, nil);
                                }
                            }];
}

- (void)authLoginWithUserName:(NSString*)userName
				 withPassword:(NSString*)password
					 loginUrl:(NSString*)loginUrl
			  verificationUrl:(NSString*)verificationUrl
				emailTemplate:(NSString*)emailTemplate
			completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/login"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"username": userName,
												@"password": password,
												@"loginUrl": loginUrl,
												@"verificationUrl": verificationUrl,
												@"emailTemplate": emailTemplate
												}
                            completionHandler:^(NSDictionary *data, NSError *error) {
                                if (error) {
                                    completion(nil, error);
                                } else {
                                    LRSession *session = [[LRSession alloc] initWithAccessToken:data[@"access_token"] userProfile:data[@"Profile"]];
                                    completion(session.userProfile, nil);
                                }
                            }];
}

- (void)authProfilesByToken:(NSString*)accessToken
		  completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/account"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken
												}
                            completionHandler:completion];
}

- (void)authSocialIdentity:(NSString*)accessToken
			 emailTemplate:(NSString*)emailTemplate
		 completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/socialIdentity"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												@"emailTemplate": emailTemplate
												}
                            completionHandler:completion];
}

- (void)authVerifyEmailWithToken:(NSString*)verificationtoken
							 url:(NSString*)url
			   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/email"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"verificationtoken": verificationtoken,
												@"url": url
												}
                            completionHandler:completion];
}

- (void)authChangePasswordWithAcessToken:(NSString*)accessToken
							 oldPassword:(NSString*)oldPassword
							 newPassword:(NSString*)newPassword
					   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/password"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												}
										 body:@{
												@"oldpassword": oldPassword,
												@"newpassword": newPassword
												}
                            completionHandler:completion];
}

- (void)authLinkSocialIdentityWithAcessToken:(NSString*)accessToken
							  candidateToken:(NSString*)candidateToken
						   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/socialIdentity"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												}
										 body:@{
												@"candidateToken": candidateToken
												}
                            completionHandler:completion];
}

- (void)authResendEmailVerification:(NSString*)email
					  emailTemplate:(NSString*)emailTemplate
					verificationUrl:(NSString*)verificationUrl
				  completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/register"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"verificationUrl": verificationUrl,
												@"emailTemplate": emailTemplate
												}
										 body:@{
												@"email": email
												}
                            completionHandler:completion];
}

- (void)authResetPasswordWithResetToken:(NSString*)resetToken
							   password:(NSString*)password
					  completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/password"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey]
												}
										 body:@{
												@"password": password,
												@"resettoken": resetToken
												}
                            completionHandler:completion];
}

- (void)authResetPasswordWithSecurityQuestion:(NSDictionary*)securityQuestion
									   userid:(NSString*)userid // if phone no login then phone no and if email login then email id
									 password:(NSString*)password
							completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/password/securityanswer"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey]
												}
										 body:@{
												@"securityanswer":securityQuestion,
												@"password": password,
												@"userid": userid
												}
                            completionHandler:completion];
}


- (void)authResetSetUserName:(NSString*)accessToken
					username:(NSString*)username
		   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/username"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												}
										 body:@{
												@"username": username,
												}
                            completionHandler:completion];
}

- (void)authUpdateProfilebyToken:(NSString*)accessToken
				 verificationUrl:(NSString*)verificationUrl
				   emailTemplate:(NSString*)emailTemplate
						userData:(NSDictionary*)userData
			   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/account"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												@"verificationUrl": verificationUrl,
												@"emailTemplate": emailTemplate
												}
										 body:userData
                            completionHandler:completion];
}

- (void)authUpdateSecurityQuestionWithAccessToken:(NSString*)accessToken
								 securityQuestion:(NSDictionary*)securityQuestion
								completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/account"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												}
										 body:@{
												@"SecurityQuestionAnswer":securityQuestion
												}
                            completionHandler:completion];
}

- (void)authDeleteAccountWithToken:(NSString*)accessToken
				   verificationUrl:(NSString*)verificationUrl
					 emailTemplate:(NSString*)emailTemplate
				 completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendDELETE:@"identity/v2/auth/account"
									 queryParams:@{
												   @"apikey": [LoginRadiusSDK apiKey],
												   @"access_token": accessToken,
												   @"verificationUrl": verificationUrl,
												   @"emailTemplate": emailTemplate
												   }
											body:nil
                               completionHandler:completion];
}

- (void)authDeleteEmailWithToken:(NSString*)accessToken
						   email:(NSString*)email
			   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendDELETE:@"identity/v2/auth/email"
									 queryParams:@{
												   @"apikey": [LoginRadiusSDK apiKey],
												   @"access_token": accessToken
												   }
											body:@{
												   @"email": email
												   }
                               completionHandler:completion];
}

- (void)authUnlinkSocialIdentityWithToken:(NSString*)accessToken
								 provider:(NSString*)provider
							   providerID:(NSString*)providerID
						completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST sharedInstance] sendDELETE:@"identity/v2/auth/socialIdentity"
									 queryParams:@{
												   @"apikey": [LoginRadiusSDK apiKey],
												   @"access_token": accessToken
												   }
											body:@{
												   @"provider": provider,
												   @"providerID": providerID
												   }
                               completionHandler:completion];
}


- (void)createCustomObjectWithAccessToken:(NSString*)token
                        customObjectName:(NSString*)objectName
                        customObjectData:(NSDictionary*)data
                       completionHandler:(LRAPIResponseHandler)completion {

    [[LoginRadiusREST sharedInstance] sendPOST:@"identity/v2/auth/customobject"
                                   queryParams:@{
                                                 @"apikey": [LoginRadiusSDK apiKey],
                                                 @"access_token": token,
                                                 @"objectname": objectName
                                                 }
                                          body:data
                             completionHandler:completion];
}

- (void)getCustomObjectWithAccessToken:(NSString*)token
                  customObjectRecordID:(NSString*)objectRecordID
                      customObjectName:(NSString*)objectName
               completionHandler:(LRAPIResponseHandler)completion {

    [[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/customobject"
                                  queryParams:@{
                                                @"apikey": [LoginRadiusSDK apiKey],
                                                @"access_token": token,
                                                @"objectrecordid": objectRecordID,
                                                @"objectname": objectName
                                                }
                            completionHandler:completion];
}

- (void)getCustomObjectWithAccessToken:(NSString*)token
                      customObjectName:(NSString*)objectName
                     completionHandler:(LRAPIResponseHandler)completion {

    [[LoginRadiusREST sharedInstance] sendGET:@"identity/v2/auth/customobject"
                                  queryParams:@{
                                                @"apikey": [LoginRadiusSDK apiKey],
                                                @"access_token": token,
                                                @"objectname": objectName
                                                }
                            completionHandler:completion];
}

- (void)updateCustomObjectWithToken:(NSString*)accessToken
               customObjectRecordID:(NSString*)objectRecordID
                   customObjectName:(NSString*)objectName
                   customObjectDate:(NSDictionary*)data
                  completionHandler:(LRAPIResponseHandler)completion {

    [[LoginRadiusREST sharedInstance] sendPUT:@"identity/v2/auth/customobject"
                                  queryParams:@{
                                                @"apikey": [LoginRadiusSDK apiKey],
                                                @"access_token": accessToken,
                                                @"objectrecordid": objectRecordID,
                                                @"objectname": objectName
                                                }
                                         body:data
                            completionHandler:completion];
}


- (void)DeleteCustomObjectWithToken:(NSString*)accessToken
               customObjectRecordID:(NSString*)objectRecordID
                   customObjectName:(NSString*)objectName
                   customObjectDate:(NSDictionary*)data
                  completionHandler:(LRAPIResponseHandler)completion {

    [[LoginRadiusREST sharedInstance] sendDELETE:@"identity/v2/auth/customobject"
                                     queryParams:@{
                                                   @"apikey": [LoginRadiusSDK apiKey],
                                                   @"access_token": accessToken,
                                                   @"objectrecordid": objectRecordID,
                                                   @"objectname": objectName
                                                   }
                                            body:nil
                               completionHandler:completion];
}


- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}
@end
