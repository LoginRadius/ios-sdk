//
//  AuthenticationAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 12/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"
#import "LRDictionary.h"
@interface AuthenticationAPI : NSObject

+ (instancetype)authInstance;

- (void)addEmailWithAccessToken:(NSString *)access_token
                  emailtemplate:(NSString *)emailtemplate
                        payload:(NSDictionary *)payload
              completionHandler:(LRAPIResponseHandler)completion;

- (void)forgotPasswordWithEmail:(NSString *)email
                  emailtemplate:(NSString *)emailtemplate
              completionHandler:(LRAPIResponseHandler)completion;

- (void)userRegistrationWithSott:(NSString *)sott
                         payload:(NSDictionary *)payload
                   emailtemplate:(NSString *)emailtemplate
                     smstemplate:(NSString *)smstemplate
         preventVerificationEmail:(BOOL)preventVerificationEmail
               completionHandler:(LRAPIResponseHandler)completion;

- (void)loginWithPayload:(NSDictionary *)payload
                loginurl:(NSString *)loginurl
           emailtemplate:(NSString *)emailtemplate
             smstemplate:(NSString *)smstemplate
    g_recaptcha_response:(NSString *)g_recaptcha_response
completionHandler:(LRAPIResponseHandler)completion;

- (void)forgotPasswordWithPhone:(NSString *)phone
                    smstemplate:(NSString *)smstemplate
              completionHandler:(LRAPIResponseHandler)completion;

- (void)resendOtpWithPhone:(NSString *)phone
               smstemplate:(NSString *)smstemplate
         completionHandler:(LRAPIResponseHandler)completion;

- (void)resendOtpWithAccessToken:(NSString *)access_token
                     smstemplate:(NSString *)smstemplate
               completionHandler:(LRAPIResponseHandler)completion;

- (void)checkEmailAvailability:(NSString *)email
             completionHandler:(LRAPIResponseHandler)completion;

- (void)checkUserNameAvailability:(NSString *)username
                completionHandler:(LRAPIResponseHandler)completion;

- (void)profilesWithAccessToken:(NSString *)access_token
              completionHandler:(LRAPIResponseHandler)completion;

- (void)privacyPolicyAcceptWithAccessToken:(NSString *)access_token
              completionHandler:(LRAPIResponseHandler)completion;

- (void)socialIdentityWithAccessToken:(NSString *)access_token
                    completionHandler:(LRAPIResponseHandler)completion;

- (void)validateAccessToken:(NSString *)access_token
          completionHandler:(LRAPIResponseHandler)completion;

- (void)verifyEmailWithVerificationToken:(NSString *)verificationtoken
                                     url:(NSString *)url
                    welcomeemailtemplate:(NSString *)welcomeemailtemplate
                       completionHandler:(LRAPIResponseHandler)completion;

- (void)deleteAccountWithDeleteToken:(NSString *)deletetoken
                   completionHandler:(LRAPIResponseHandler)completion;

- (void)invalidateAccessToken:(NSString *)access_token
            completionHandler:(LRAPIResponseHandler)completion;

- (void)getSecurityQuestionsWithAccessToken:(NSString *)access_token
                          completionHandler:(LRAPIResponseHandler)completion;

- (void)getSecurityQuestionsWithEmail:(NSString *)email
                    completionHandler:(LRAPIResponseHandler)completion;

- (void)getSecurityQuestionsWithUserName:(NSString *)username
                       completionHandler:(LRAPIResponseHandler)completion;

- (void)getSecurityQuestionsWithPhone:(NSString *)phone
                    completionHandler:(LRAPIResponseHandler)completion;


- (void)phoneLoginWithOtp:(NSString *)otp
                    phone:(NSString *)phone
              smstemplate:(NSString *)smstemplate
        completionHandler:(LRAPIResponseHandler)completion;

- (void)phoneNumberAvailability:(NSString *)phone
              completionHandler:(LRAPIResponseHandler)completion;


- (void)sendOtpWithPhone:(NSString *)phone
             smstemplate:(NSString *)smstemplate
       completionHandler:(LRAPIResponseHandler)completion;


- (void)changePasswordWithAccessToken:(NSString *)access_token
                          oldpassword:(NSString *)oldpassword
                          newpassword:(NSString *)newpassword
                    completionHandler:(LRAPIResponseHandler)completion;

- (void)linkSocialIdentitiesWithAccessToken:(NSString *)access_token
                             candidatetoken:(NSString *)candidatetoken
                          completionHandler:(LRAPIResponseHandler)completion;


- (void)resendEmailVerification:(NSString *)email
                        emailtemplate:(NSString *)emailtemplate
              completionHandler:(LRAPIResponseHandler)completion;


- (void)resetPasswordByResetToken:(NSDictionary *)payload
                completionHandler:(LRAPIResponseHandler)completion;


- (void)resetPasswordBySecurityAnswer_and_Email:(NSDictionary *)payload
                              completionHandler:(LRAPIResponseHandler)completion;


- (void)resetPasswordBySecurityAnswer_and_Phone:(NSDictionary *)payload
                              completionHandler:(LRAPIResponseHandler)completion;


- (void)resetPasswordBySecurityAnswer_and_UserName:(NSDictionary *)payload
                                 completionHandler:(LRAPIResponseHandler)completion;


- (void)changeUserNameWithAccessToken:(NSString *)access_token
                             username:(NSString *)username
                    completionHandler:(LRAPIResponseHandler)completion;


- (void)updateProfileWithAccessToken:(NSString *)access_token
                       emailtemplate:(NSString *)emailtemplate
                         smstemplate:(NSString *)smstemplate
                             payload:(NSDictionary *)payload
                   completionHandler:(LRAPIResponseHandler)completion;


- (void)updateSecurityQuestionWithAccessToken:(NSString *)access_token
                                      payload:(NSDictionary *)payload
                            completionHandler:(LRAPIResponseHandler)completion;


- (void)phoneNumberUpdateWithAccessToken:(NSString *)access_token
                                   phone:(NSString *)phone
                             smstemplate:(NSString *)smstemplate
                       completionHandler:(LRAPIResponseHandler)completion;


- (void)phoneResetPasswordByOtpWithPayload:(NSDictionary *)payload
               completionHandler:(LRAPIResponseHandler)completion;


- (void)phoneVerificationWithOtp:(NSString *)otp
                           phone:(NSString *)phone
                     smstemplate:(NSString *)smstemplate
               completionHandler:(LRAPIResponseHandler)completion;


- (void)phoneVerificationOtpWithAccessToken:(NSString *)access_token
                                        otp:(NSString *)otp
                                smstemplate:(NSString *)smstemplate
                          completionHandler:(LRAPIResponseHandler)completion;

- (void)verifyEmailByOtpWithPayload:(NSDictionary *)payload
                                url:(NSString *)url
               welcomeemailtemplate:(NSString *)welcomeemailtemplate
                          completionHandler:(LRAPIResponseHandler)completion;

- (void)resetPasswordByOtpWithPayload:(NSDictionary *)payload
                  completionHandler:(LRAPIResponseHandler)completion;


-(void)sendWelcomeEmailWithAccessToken:(NSString *)access_token
                  welcomeemailtemplate:(NSString *)welcomeemailtemplate
                     completionHandler:(LRAPIResponseHandler)completion;


- (void)deleteAccountWithEmailConfirmation:(NSString *)access_token
                             emailtemplate:(NSString *)emailtemplate
                         completionHandler:(LRAPIResponseHandler)completion;


- (void)removeEmailWithAccessToken:(NSString *)access_token
                             email:(NSString *)email
                 completionHandler:(LRAPIResponseHandler)completion;



- (void)removePhoneIDWithAccessToken:(NSString *)access_token
                 completionHandler:(LRAPIResponseHandler)completion;


- (void)unlinkSocialIdentitiesWithAccessToken:(NSString *)access_token
                                     provider:(NSString *)provider
                                   providerid:(NSString *)providerid
                            completionHandler:(LRAPIResponseHandler)completion;


@end
