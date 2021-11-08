//
//  AuthenticationAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 12/12/17.
//

#import "AuthenticationAPI.h"


@implementation AuthenticationAPI

+ (instancetype)authInstance{
    static dispatch_once_t onceToken;
    static AuthenticationAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[AuthenticationAPI alloc] init];
    });
    
    return instance;
}


                 /* ******************************* Post Method  **********************************/



- (void)addEmailWithAccessToken:(NSString *)access_token
                    emailtemplate:(NSString *)emailtemplate
                    payload:(NSDictionary *)payload
  completionHandler:(LRAPIResponseHandler)completion {
     NSString *email_template = emailtemplate ? emailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/email"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"access_token": access_token,
                                              @"verificationurl": [LoginRadiusSDK verificationUrl],
                                              @"emailtemplate": email_template
                                              }
                                       body:payload
                          completionHandler:completion];
}

- (void)forgotPasswordWithEmail:(NSString *)email
       emailtemplate:(NSString *)emailtemplate
   completionHandler:(LRAPIResponseHandler)completion {
    NSString *key=@"";
    if ([email containsString:@"@"]){
        key = @"email";
    }else{
        key= @"username";
    }
     NSString *email_template = emailtemplate ? emailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/password"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"resetpasswordurl": [LoginRadiusSDK verificationUrl],
                                              @"emailtemplate": email_template
                                              }
                                       body:@{
                                              key:email
                                              }
                          completionHandler:completion];
}

- (void)userRegistrationWithSott:(NSString *)sott
                         payload:(NSDictionary *)payload
                   emailtemplate:(NSString *)emailtemplate
                     smstemplate:(NSString *)smstemplate
        preventVerificationEmail:(BOOL)preventVerificationEmail
         completionHandler:(LRAPIResponseHandler)completion {
     NSString *email_template = emailtemplate ? emailtemplate: @"";
     NSString *sms_template = smstemplate ? smstemplate: @"";
             NSString *prevent_verificationEmail = @"";
    if ([sott containsString:@"%"]){
        sott = [sott stringByRemovingPercentEncoding];
    }if(preventVerificationEmail == YES){
        prevent_verificationEmail = @"PreventVerificationEmail";
    }
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/register"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"registrationsource":[LoginRadiusSDK registrationSource],
                                              @"sott": sott,
                                              @"verificationurl": [LoginRadiusSDK verificationUrl],
                                              @"emailtemplate": email_template,
                                              @"smstemplate":sms_template,
                                              @"options":prevent_verificationEmail
                                              }
                                       body:payload
                          completionHandler:completion];
}



- (void)loginWithPayload:(NSDictionary *)payload
                loginurl:(NSString *)loginurl
          emailtemplate:(NSString *)emailtemplate
          smstemplate:(NSString *)smstemplate
        g_recaptcha_response:(NSString *)g_recaptcha_response

    completionHandler:(LRAPIResponseHandler)completion {
     NSString *login_url = loginurl ? loginurl: @"";
     NSString *email_template = emailtemplate ? emailtemplate: @"";
     NSString *sms_template = smstemplate ? smstemplate: @"";
     NSString *recaptcha_response = g_recaptcha_response ? g_recaptcha_response: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/login"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"verificationurl": [LoginRadiusSDK verificationUrl],
                                              @"loginurl": login_url,
                                              @"emailtemplate": email_template,
                                              @"smstemplate": sms_template,
                                              @"g-recaptcha-response": recaptcha_response
                                              }
                                       body:payload
                          completionHandler:completion];
}

- (void)forgotPasswordWithPhone:(NSString *)phone
                    smstemplate:(NSString *)smstemplate
       completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/password/otp"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"smstemplate": sms_template
                                              }
                                       body:@{
                                              @"phone":phone
                                              }
                          completionHandler:completion];
}

- (void)resendOtpWithPhone:(NSString *)phone
                smstemplate:(NSString *)smstemplate
                   completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/phone/otp"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"smstemplate": sms_template
                                              }
                                       body:@{
                                              @"phone":phone
                                              }
                          completionHandler:completion];
}

- (void)resendOtpWithAccessToken:(NSString *)access_token
                      smstemplate:(NSString *)smstemplate
                     completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/phone/otp"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"access_token":access_token,
                                              @"smstemplate": sms_template
                                              }
                                       body:@{}
                          completionHandler:completion];
}



             /* ******************************* Get Method  **********************************/


- (void)checkEmailAvailability:(NSString *)email
            completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"email": email
                                             }
                         completionHandler:completion];
    
}

- (void)checkUserNameAvailability:(NSString *)username
                 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/username"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"username": username
                                             }
                         completionHandler:completion];
    
}

- (void)profilesWithAccessToken:(NSString *)access_token
                    completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/account"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                           completionHandler:completion];
    
}

- (void)socialIdentityWithAccessToken:(NSString *)access_token
                 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/socialidentity"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)validateAccessToken:(NSString *)access_token
         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/access_token/validate"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)verifyEmailWithVerificationToken:(NSString *)verificationtoken
                        url:(NSString *)url
                        welcomeemailtemplate:(NSString *)welcomeemailtemplate
                        completionHandler:(LRAPIResponseHandler)completion {
     NSString *_url = url ? url: @"";
     NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"verificationtoken": verificationtoken,
                                             @"url":_url,
                                             @"welcomeemailtemplate":welcome_emailtemplate
                                             }
                         completionHandler:completion];
    
}

- (void)deleteAccountWithDeleteToken:(NSString *)deletetoken
              completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/account/delete"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"deletetoken": deletetoken
                                             }
                         completionHandler:completion];
    
}

- (void)invalidateAccessToken:(NSString *)access_token
        completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/access_token/invalidate"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getSecurityQuestionsWithAccessToken:(NSString *)access_token
                completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/securityquestion/accesstoken"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getSecurityQuestionsWithEmail:(NSString *)email
                            completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/securityquestion/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"email": email
                                             }
                         completionHandler:completion];
    
}

- (void)getSecurityQuestionsWithUserName:(NSString *)username
                      completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/securityquestion/username"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"username": username
                                             }
                         completionHandler:completion];
    
}

- (void)getSecurityQuestionsWithPhone:(NSString *)phone
                         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/securityquestion/phone"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"phone": phone
                                             }
                         completionHandler:completion];
    
}

- (void)phoneLoginWithOtp:(NSString *)otp
                        phone:(NSString *)phone
                        smstemplate:(NSString *)smstemplate
                      completionHandler:(LRAPIResponseHandler)completion {
    NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"phone": phone,
                                             @"otp": otp,
                                             @"smstemplate": sms_template
                                             }
                         completionHandler:completion];
    
}

- (void)phoneNumberAvailability:(NSString *)phone
          completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/phone"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"phone": phone
                                           }
                         completionHandler:completion];
    
}

- (void)sendOtpWithPhone:(NSString *)phone
            smstemplate:(NSString *)smstemplate
            completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/otp"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"phone": phone,
                                             @"smstemplate": sms_template
                                             }
                         completionHandler:completion];
    
}


-(void)sendWelcomeEmailWithAccessToken:(NSString *)access_token welcomeemailtemplate:(NSString *)welcomeemailtemplate completionHandler:(LRAPIResponseHandler)completion{
    NSString *welcomeemail_template = welcomeemailtemplate ? welcomeemailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/account/sendwelcomeemail"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token,
                                             @"welcomeemailtemplate": welcomeemail_template
                                             }
                         completionHandler:completion];
    
}


-(void)privacyPolicyAcceptWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion{
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/privacypolicy/accept"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}


               /* ******************************* Put Method  **********************************/


- (void)changePasswordWithAccessToken:(NSString *)access_token
                         oldpassword:(NSString *)oldpassword
                         newpassword:(NSString *)newpassword
     completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/change"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"access_token":access_token
                                             }
                                      body:@{
                                             @"oldpassword":oldpassword,
                                             @"newpassword":newpassword
                                             }
                          completionHandler:completion];
}

- (void)linkSocialIdentitiesWithAccessToken:(NSString *)access_token
                    candidatetoken:(NSString *)candidatetoken
         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/socialidentity"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token
                                             }
                                      body:@{
                                             @"candidatetoken":candidatetoken
                                             }
                         completionHandler:completion];
}

- (void)resendEmailVerification:(NSString *)email
                        emailtemplate:(NSString *)emailtemplate
               completionHandler:(LRAPIResponseHandler)completion {
    NSString *email_template = emailtemplate ? emailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/register"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"verificationurl":[LoginRadiusSDK verificationUrl],
                                             @"emailtemplate":email_template
                                             }
                                      body:@{
                                             @"email":email
                                             }
                         completionHandler:completion];
}

- (void)resetPasswordByResetToken:(NSDictionary *)payload
               completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/reset"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPasswordBySecurityAnswer_and_Email:(NSDictionary *)payload
                    completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/securityanswer"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPasswordBySecurityAnswer_and_Phone:(NSDictionary *)payload
                                  completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/securityanswer"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)resetPasswordBySecurityAnswer_and_UserName:(NSDictionary *)payload
                                  completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/securityanswer"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)changeUserNameWithAccessToken:(NSString *)access_token
                      username:(NSString *)username
         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/username"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token
                                             }
                                      body:@{
                                             @"username":username
                                             }
                         completionHandler:completion];
}

- (void)updateProfileWithAccessToken:(NSString *)access_token
                   emailtemplate:(NSString *)emailtemplate
                   smstemplate:(NSString *)smstemplate
                      payload:(NSDictionary *)payload
         completionHandler:(LRAPIResponseHandler)completion {
    NSString *email_template = emailtemplate ? emailtemplate: @"";
    NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/account"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token,
                                             @"verificationurl":[LoginRadiusSDK verificationUrl],
                                             @"emailtemplate":email_template,
                                             @"smstemplate":sms_template
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)updateSecurityQuestionWithAccessToken:(NSString *)access_token
                                          payload:(NSDictionary *)payload
         completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/account"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)phoneNumberUpdateWithAccessToken:(NSString *)access_token
                        phone:(NSString *)phone
                  smstemplate:(NSString *)smstemplate

     completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/phone"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token,
                                             @"smstemplate":sms_template
                                             }
                                      body:@{
                                             @"phone":phone
                                             }
                         completionHandler:completion];
}

- (void)phoneResetPasswordByOtpWithPayload:(NSDictionary *)payload
            completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/otp"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

- (void)phoneVerificationWithOtp:(NSString *)otp
                       phone:(NSString *)phone
                       smstemplate:(NSString *)smstemplate

            completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/phone/otp"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"otp":otp,
                                             @"smstemplate":sms_template
                                             }
                                      body:@{
                                             @"phone":phone
                                             }
                         completionHandler:completion];
}

- (void)phoneVerificationOtpWithAccessToken:(NSString *)access_token
                            otp:(NSString *)otp
                       smstemplate:(NSString *)smstemplate
                 completionHandler:(LRAPIResponseHandler)completion {
     NSString *sms_template = smstemplate ? smstemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/phone/otp"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token,
                                             @"otp":otp,
                                             @"smstemplate":sms_template
                                             }
                                      body:@{}
                         completionHandler:completion];
}


- (void)verifyEmailByOtpWithPayload:(NSDictionary *)payload
                                        url:(NSString *)url
                                welcomeemailtemplate:(NSString *)welcomeemailtemplate
                          completionHandler:(LRAPIResponseHandler)completion {
    NSString *_url = url ? url: @"";
    NSString *welcome_emailtemplate = welcomeemailtemplate ? welcomeemailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"url":_url,
                                             @"welcomeemailtemplate":welcome_emailtemplate
                                             }
                                      body:payload
                         completionHandler:completion];
}


-(void)resetPasswordByOtpWithPayload:(NSDictionary *)payload completionHandler:(LRAPIResponseHandler)completion{
    [[LoginRadiusREST apiInstance] sendPUT:@"identity/v2/auth/password/reset"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                                      body:payload
                         completionHandler:completion];
}

            /* ******************************* Delete Method  **********************************/


- (void)deleteAccountWithEmailConfirmation:(NSString *)access_token
                            emailtemplate:(NSString *)emailtemplate
                      completionHandler:(LRAPIResponseHandler)completion {
     NSString *email_template = emailtemplate ? emailtemplate: @"";
    [[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/account"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token,
                                             @"deleteurl":[LoginRadiusSDK verificationUrl],
                                             @"emailtemplate":email_template
                                             }
                                      body:@{}
                         completionHandler:completion];
}


- (void)removeEmailWithAccessToken:(NSString *)access_token
            email:(NSString *)email
                 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/email"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token
                                             }
                                         body:@{
                                                @"email":email
                                                }
                         completionHandler:completion];
}


- (void)removePhoneIDWithAccessToken:(NSString *)access_token
                   completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/phone"
                                  queryParams:@{
                                                @"apikey": [LoginRadiusSDK apiKey],
                                                @"access_token":access_token
                                                }
                                         body:@{}
                            completionHandler:completion];
}


- (void)unlinkSocialIdentitiesWithAccessToken:(NSString *)access_token
                   provider:(NSString *)provider
                   providerid:(NSString *)providerid
      completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendDELETE:@"identity/v2/auth/socialidentity"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token":access_token
                                             }
                                         body:@{
                                                @"provider":provider,
                                                @"providerid":providerid
                                                }
                         completionHandler:completion];
}




@end


