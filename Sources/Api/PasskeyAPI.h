//
//  PasskeyAPI.h
//  Pods
//
//  Created by Megha Agarwal  on 29/08/25.
//


#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "LoginRadius.h"

@interface PasskeyAPI : NSObject <ASAuthorizationControllerDelegate>

+ (instancetype)passkeyInstance;

// Set presentation context
- (void)setPresentationContext:(UIViewController<ASAuthorizationControllerPresentationContextProviding> *)presentingVC;

// Registration Flow
- (void)beginRegistrationWithPasskey:(NSString *)email
                         completion:(LRAPIResponseHandler)completion;

- (void)finishRegistrationWithPasskey:(NSDictionary *)passkey
                           completion:(LRAPIResponseHandler)completion;

// Login Flow
- (void)beginLoginWithPasskey:(NSString *)email
                   completion:(LRAPIResponseHandler)completion;

- (void)finishLoginWithPasskey:(NSDictionary *)passkey
                    completion:(LRAPIResponseHandler)completion;

// Autofill Login Flow
- (void)beginAutofillLoginWithPasskey:(LRAPIResponseHandler)completion;

- (void)finishAutofillLoginWithPasskey:(NSDictionary *)passkey
                            completion:(LRAPIResponseHandler)completion;

// Add Passkey Flow (to existing account)
- (void)beginAddPasskeyWithToken:(NSString *)accesstoken
                        completion:(LRAPIResponseHandler)completion;

- (void)finishAddPasskeyWithPasskey:(NSDictionary *)passkey
                         completion:(LRAPIResponseHandler)completion;

// List Passkeys 
- (void)listPasskeys:(NSString *)access_token
              completionHandler:(LRAPIResponseHandler)completion;

// Delete Passkey as it requires api secret
- (void)deletePasskeyWithPasskeyId:(NSString *)passkeyId
                        accesstoken:(NSString *)accesstoken
                  completionHandler:(LRAPIResponseHandler)completion;


@end



