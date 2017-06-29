//
//  LoginRadiusRegistrationManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRegistrationManager.h"
#import "LoginRadiusREST.h"
#import "LRSession.h"
#import "NSMutableDictionary+LRMutableDictionary.h"
#import "LoginRadiusRegistrationSchema.h"
#import "NSDictionary+LRDictionary.h"


static NSString * const defaultUrl = @"https://auth.lrcontent.com/mobile/verification/index.html";

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

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/email"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"verificationUrl": veriUrl,
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

    NSString *resetUrl = (resetPasswordUrl == nil || [resetPasswordUrl isEqualToString:@""]) ? defaultUrl : resetPasswordUrl;

	[[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/password"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"resetPasswordUrl": resetUrl,
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
    
    //decode any encoded sott
    if ([sott containsString:@"%"])
    {
        sott = [sott stringByRemovingPercentEncoding];
    }

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/register"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"sott": sott,
												 @"verificationUrl": veriUrl,
												 @"emailTemplate": emailTemplate
												 }
										  body: data
                             completionHandler:completion];
}

- (void)authCheckEmailAvailability:(NSString*)email
				 completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/email"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"email": email
												}
                            completionHandler:completion];
}

- (void)authUserNameAvailability:(NSString*)email
			   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/username"
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

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"email": email,
												@"password": password,
												@"loginUrl": loginUrl,
												@"verificationUrl": veriUrl,
												@"emailTemplate": emailTemplate
												}
							completionHandler:^(NSDictionary *data, NSError *error) {
                                if (error) {
                                    completion(nil, error);
                                } else {
                                    [self checkUserProfileForVerifiedAndRequiredFieldsWithToken:data[@"access_token"] data:data[@"Profile"] completion:completion];
                                }
                            }];
}

- (void)authLoginWithUserName:(NSString*)userName
				 withPassword:(NSString*)password
					 loginUrl:(NSString*)loginUrl
			  verificationUrl:(NSString*)verificationUrl
				emailTemplate:(NSString*)emailTemplate
			completionHandler:(LRAPIResponseHandler)completion {

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"username": userName,
												@"password": password,
												@"loginUrl": loginUrl,
												@"verificationUrl": veriUrl,
												@"emailTemplate": emailTemplate
												}
                            completionHandler:^(NSDictionary *data, NSError *error) {
                                if (error) {
                                    completion(nil, error);
                                } else {
                                    [self checkUserProfileForVerifiedAndRequiredFieldsWithToken:data[@"access_token"] data:data[@"Profile"] completion:completion];
                                }
                            }];
}

- (void)authProfilesByToken:(NSString*)accessToken
		  completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/account"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken
												}
                            completionHandler:^(NSDictionary *data, NSError *error) {
        if (error) {
            completion(nil, error);
		} else {
            [self checkUserProfileForVerifiedAndRequiredFieldsWithToken:accessToken data:data completion:completion];
		}
    }];
}

- (void)authSocialIdentity:(NSString*)accessToken
			 emailTemplate:(NSString*)emailTemplate
		 completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/socialIdentity"
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

	[[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/email"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"verificationtoken": verificationtoken,
												@"url": url
												}
                            completionHandler:completion];
}

- (void)authChangePasswordWithAccessToken:(NSString*)accessToken
							 oldPassword:(NSString*)oldPassword
							 newPassword:(NSString*)newPassword
					   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password"
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

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/socialIdentity"
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

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/register"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"verificationUrl": veriUrl,
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

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password"
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

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/securityanswer"
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

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/username"
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

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/account"
								  queryParams:@{
												@"apikey": [LoginRadiusSDK apiKey],
												@"access_token": accessToken,
												@"verificationUrl": veriUrl,
												@"emailTemplate": emailTemplate
												}
										 body:userData
                            completionHandler:completion];
}

- (void)authUpdateSecurityQuestionWithAccessToken:(NSString*)accessToken
								 securityQuestion:(NSDictionary*)securityQuestion
								completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/account"
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

    NSString *veriUrl = (verificationUrl == nil || [verificationUrl isEqualToString:@""]) ? defaultUrl : verificationUrl;

	[[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/account"
									 queryParams:@{
												   @"apikey": [LoginRadiusSDK apiKey],
												   @"access_token": accessToken,
												   @"verificationUrl": veriUrl,
												   @"emailTemplate": emailTemplate
												   }
											body:nil
                               completionHandler:completion];
}

- (void)authDeleteEmailWithToken:(NSString*)accessToken
						   email:(NSString*)email
			   completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/email"
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

	[[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/socialIdentity"
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

- (void)authValidateAccessToken:(NSString*)accessToken
						completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendGET:@"/identity/v2/auth/access_token/validate"
									 queryParams:@{
												   @"apikey": [LoginRadiusSDK apiKey],
												   @"access_token": accessToken
												   }
                               completionHandler:completion];
}

- (void)authInvalidateAccessToken:(NSString*)accessToken
						completionHandler:(LRAPIResponseHandler)completion {

	[[LoginRadiusREST apiInstance] sendGET:@"/identity/v2/auth/access_token/invalidate"
									 queryParams:@{
												   @"apikey": [LoginRadiusSDK apiKey],
												   @"access_token": accessToken
												   }
                               completionHandler:completion];
}

- (void)getRegistrationSchema:(LRAPIResponseHandler)completion {

    NSString *url = [NSString stringWithFormat:@"raas/regSchema/%@.json",[LoginRadiusSDK apiKey]];
    
	[[LoginRadiusREST cdnInstance] sendGET:url
                               queryParams:nil
                         completionHandler:^(NSDictionary *data, NSError *error)
                         {
                            if (error)
                            {
                                completion(nil,error);
                            }else
                            {
                                NSArray* jsonArray = (NSArray*) data;
                                [[LoginRadiusRegistrationSchema sharedInstance] setWithArrayOfDictionary:jsonArray];
                                NSDictionary *regSchema = @{@"RegistrationSchema":[[LoginRadiusRegistrationSchema sharedInstance] fields]};
                                
                                completion(regSchema,error);
                            }
                         }];
}

- (void)checkUserProfileForVerifiedAndRequiredFieldsWithToken: (NSString *) accessToken
                                                data: (NSDictionary *)data
                                          completion: (LRAPIResponseHandler) completion
{
    //should get mandatory fields
    NSDictionary *lowercasedProfile = [data dictionaryWithLowercaseKeys];

    //check if we need to ask for fields
    if ([[LoginRadiusSDK sharedInstance] askForRequiredFields])
    {
        NSArray<LoginRadiusField *> *rFields = [LoginRadiusRegistrationSchema sharedInstance].requiredUserProfileFields;
        
        NSMutableArray<LoginRadiusField *> *unfilledFields = [[NSMutableArray<LoginRadiusField *> alloc] init];
        for(LoginRadiusField* field in rFields)
        {

            NSString *fName = [field name];
            
            //registration schema has hardcoded parameter name of emailid, userprofile returns as email
            if([fName isEqual:@"emailid"])
            {
                fName = [fName substringWithRange:NSMakeRange(0,[fName length] - 2)];
            }
            
            id target = [lowercasedProfile objectForKey:fName];
            
            //check for required custom field
            if ([fName hasPrefix:@"cf_"])
            {
                NSString *cField = [fName substringWithRange:NSMakeRange(3, [fName length]-3)];
                
                target = [lowercasedProfile objectForKey:@"customfields"];
                if ( ![target isEqual: (id)[NSNull null]] )
                {
                    target = [target objectForKey:cField];
                }
            }
            //if parameter is an address parameter
            else if ([[LoginRadiusField addressFields] containsObject:fName])
            {
                target = [lowercasedProfile objectForKey:@"addresses"];
                if ( ![target isEqual: (id)[NSNull null]] )
                {
                    NSArray *arr = (NSArray *) target;
                    if ([arr count] > 0)
                    {
                        target = [arr[0] objectForKey:fName];
                    }
                }
            }
            
            //check for a required field but its an empty string
            BOOL isEmptyStr = NO;
            if ([target isKindOfClass:NSString.class])
            {
                isEmptyStr = ([target length] <= 0);
            }
            
            // if the required field is missing from the user profile, add missing required fields into the array
            if ([target isEqual: (id)[NSNull null]] || target == nil || isEmptyStr)
            {
                [unfilledFields addObject:field];
            }
        }
        
        //call UI to fill the fields
        if([unfilledFields count] > 0)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:unfilledFields forKey:@"MissingRequiredFields"];
            [dict setObject:accessToken forKey:@"AccessToken"];
            completion([dict copy], [LRErrors userProfileRequireAdditionalFields]);
            return;
        }
    }


    //check if we need to check for verification
    if ([[LoginRadiusSDK sharedInstance] askForVerifiedFields])
    {
        NSArray<LoginRadiusField*> *vFields = [LoginRadiusRegistrationSchema sharedInstance].requiredVerifiedFields;
        for(LoginRadiusField* field in vFields)
        {
            //replace "id" with "verified"
            NSString *newFieldName = [[field name] substringWithRange:NSMakeRange(0,[[field name] length] - 2)];
            newFieldName = [newFieldName stringByAppendingString:@"verified"];
            
            
            if ([(NSNumber *)[lowercasedProfile objectForKey:newFieldName] isEqual:@0])
            {
                NSRange fieldIDRange = [[field name] rangeOfString:@"id"];
                completion(nil, [LRErrors userIsNotVerified:[[field name] substringWithRange:NSMakeRange(0, fieldIDRange.location)]]);
                return;
            }
        }
    }
    
    
    //User is verified and no fields are missing
    NSMutableDictionary *dataFormatted = [[data mutableCopy] replaceNullWithBlank];
    LRSession *session = [[LRSession alloc] initWithAccessToken:accessToken userProfile:dataFormatted];
    completion(session.userProfile, nil);
}

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}
@end
