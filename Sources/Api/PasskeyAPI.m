//
//  PasskeyAPI.m
//  LoginRadiusSDK
//
//  Created by Megha Agarwal  on 29/08/25.
//

#import "PasskeyAPI.h"

#import <Foundation/Foundation.h>


@interface NSData (Base64URL)
- (NSString *)base64URLEncodedString;
+ (NSData *)dataWithBase64URLString:(NSString *)base64URL;
@end

@implementation NSData (Base64URL)
- (NSString *)base64URLEncodedString {
    NSString *base64 = [self base64EncodedStringWithOptions:0];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return base64;
}

+ (NSData *)dataWithBase64URLString:(NSString *)base64URL {
    NSString *base64 = [base64URL stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSUInteger paddedLength = base64.length + (4 - (base64.length % 4)) % 4;
    base64 = [base64 stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
    return [[NSData alloc] initWithBase64EncodedString:base64 options:0];
}
@end

@interface PasskeyAPI ()

@property (nonatomic, strong) NSString *currentRpId;
@property (nonatomic, strong) NSDictionary *currentPublicKey;
@property (nonatomic, assign) BOOL currentIsRegistration;
@property (nonatomic, assign) BOOL currentIsAdd;
@property (nonatomic, assign) BOOL currentIsAutofill;
@property (nonatomic, strong) NSString *currentIdentifier;
@property (nonatomic, strong) NSString *currentAccessToken;
@property (nonatomic, copy) LRAPIResponseHandler currentCompletion;
@property (nonatomic, weak) UIViewController<ASAuthorizationControllerPresentationContextProviding> *currentPresentingVC;

@end

@implementation PasskeyAPI

+ (instancetype)passkeyInstance {
    static dispatch_once_t onceToken;
    static PasskeyAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[PasskeyAPI alloc] init];
    });
    
    return instance;
}

-(void)setPresentationContext:(UIViewController<ASAuthorizationControllerPresentationContextProviding> *)presentingVC {
    self.currentPresentingVC = presentingVC;
}

#pragma mark - Registration Flow

- (void)beginRegistrationWithPasskey:(NSString *)email
                         completion:(LRAPIResponseHandler)completion {
    if (!self.currentPresentingVC) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Presentation context not set. Call setPresentationContext: first."}]);
        return;
    }
    
    NSString *identifier = @"";
    identifier = email;

    self.currentIsRegistration = YES;
    self.currentIsAdd = NO;
    self.currentIdentifier = identifier;
    self.currentCompletion = completion;
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/register/passkey/begin"
                               queryParams:@{

                                   @"apikey": [LoginRadiusSDK apiKey],
                                   @"identifier": identifier
                               }
                         completionHandler:^(NSDictionary *response, NSError *error) {
        if (error) {
            self.currentCompletion(nil, error);
            [self resetCurrentState];
            return;
        }
        
        NSLog(@"Response is: %@", response);

        self.currentPublicKey = response[@"RegisterBeginCredential"][@"publicKey"];

           [self performRegistrationRequest];
    }];
}

- (void)performRegistrationRequest {
    if (!self.currentPublicKey || !self.currentPresentingVC) {
        self.currentCompletion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"No public key or presentation context available"}]);
        [self resetCurrentState];
        return;
    }
    NSData *challenge = [NSData dataWithBase64URLString:self.currentPublicKey[@"challenge"]];
    NSData *userID = [NSData dataWithBase64URLString:self.currentPublicKey[@"user"][@"id"]];
    NSString *userName = self.currentPublicKey[@"user"][@"name"];
    self.currentRpId = self.currentPublicKey[@"rp"][@"id"];
    
    ASAuthorizationPlatformPublicKeyCredentialProvider *provider = [[ASAuthorizationPlatformPublicKeyCredentialProvider alloc] initWithRelyingPartyIdentifier:self.currentRpId];
    ASAuthorizationPlatformPublicKeyCredentialRegistrationRequest *request = [provider createCredentialRegistrationRequestWithChallenge:challenge name:userName userID:userID];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self.currentPresentingVC;
    [controller performRequests];
}

- (void)finishRegistrationWithPasskey:(NSDictionary *)passkey
                           completion:(LRAPIResponseHandler)completion {
    if (!self.currentPublicKey || !self.currentIdentifier) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Begin registration first"}]);
        [self resetCurrentState];
        return;
    }
    ASAuthorizationPlatformPublicKeyCredentialRegistration *credential = nil;
    if ([passkey[@"credential"] isKindOfClass:[ASAuthorizationPlatformPublicKeyCredentialRegistration class]]) {
        credential = passkey[@"credential"];
    }
    if (!credential) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Invalid credential"}]);
        [self resetCurrentState];
        return;
    }
    

    // Construct the payload based on the curl request
    NSDictionary *email = @{
        @"Type": @"Primary",
        @"Value": self.currentIdentifier ?: @""
    };

    NSDictionary *payload = @{
        @"Email": @[email],
        @"PasskeyCredential": @{
            @"id": [credential.credentialID base64URLEncodedString],
            @"rawId": [credential.credentialID base64URLEncodedString],
            @"type": @"public-key",
            @"response": @{
                @"attestationObject": [credential.rawAttestationObject base64URLEncodedString],
                @"clientDataJSON": [credential.rawClientDataJSON base64URLEncodedString]
            }
        }
    };
   
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/register/passkey/finish"
                                    queryParams:@{
                                        @"apikey": [LoginRadiusSDK apiKey]
                                    }
                                           body:payload
                              completionHandler:^(NSDictionary *response, NSError *error) {
            completion(response, error);
            [self resetCurrentState];
        }];
    }

#pragma mark - Login Flow

- (void)beginLoginWithPasskey:(NSString *)email
                   completion:(LRAPIResponseHandler)completion {
    if (!self.currentPresentingVC) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Presentation context not set. Call setPresentationContext: first."}]);
        return;
    }
    
    NSString *identifier = @"";
    identifier = email;

    self.currentIsAdd = NO;
    self.currentIsAutofill = NO;
    self.currentIdentifier = identifier;
    self.currentCompletion = completion;
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/passkey/begin"
                               queryParams:@{
                                   @"apikey": [LoginRadiusSDK apiKey],
                                   @"identifier": identifier
                               }
                         completionHandler:^(NSDictionary *response, NSError *error) {
        if (error) {
            self.currentCompletion(nil, error);
            [self resetCurrentState];
            return;
        }
        NSLog(@"Response of passkey login is: %@", response);
        self.currentPublicKey = response[@"LoginBeginCredential"][@"publicKey"];
        [self performAssertionRequest];
    }];
}

- (void)performAssertionRequest {
    if (!self.currentPublicKey || !self.currentPresentingVC) {
        self.currentCompletion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"No public key or presentation context available"}]);
        [self resetCurrentState];
        return;
    }
    NSData *challenge = [NSData dataWithBase64URLString:self.currentPublicKey[@"challenge"]];
    self.currentRpId = self.currentPublicKey[@"rpId"];
    
    ASAuthorizationPlatformPublicKeyCredentialProvider *provider = [[ASAuthorizationPlatformPublicKeyCredentialProvider alloc] initWithRelyingPartyIdentifier:self.currentRpId];
    ASAuthorizationPlatformPublicKeyCredentialAssertionRequest *request = [provider createCredentialAssertionRequestWithChallenge:challenge];
    
    NSMutableArray *allowedCreds = [NSMutableArray array];
    for (NSDictionary *cred in self.currentPublicKey[@"allowCredentials"] ?: @[]) {
        NSData *credID = [NSData dataWithBase64URLString:cred[@"id"]];
        ASAuthorizationPlatformPublicKeyCredentialDescriptor *desc = [[ASAuthorizationPlatformPublicKeyCredentialDescriptor alloc] initWithCredentialID:credID];
        [allowedCreds addObject:desc];
    }
    request.allowedCredentials = allowedCreds;
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

- (void)finishLoginWithPasskey:(NSDictionary *)passkey
                    completion:(LRAPIResponseHandler)completion {
    if (!self.currentPublicKey || !self.currentIdentifier) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Begin login first"}]);
        [self resetCurrentState];
        return;
    }
    ASAuthorizationPlatformPublicKeyCredentialAssertion *credential = nil;
    if ([passkey[@"credential"] isKindOfClass:[ASAuthorizationPlatformPublicKeyCredentialAssertion class]]) {
        credential = passkey[@"credential"];
    }
    if (!credential) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Invalid credential"}]);
        [self resetCurrentState];
        return;
    }
    
    
    NSString *email = self.currentIdentifier ?: @"";

    NSDictionary *responseDict = @{
        @"authenticatorData": [credential.rawAuthenticatorData base64URLEncodedString],
        @"clientDataJSON": [credential.rawClientDataJSON base64URLEncodedString],
        @"signature": [credential.signature base64URLEncodedString],
        @"userHandle": credential.userID ? [credential.userID base64URLEncodedString] : [NSNull null]
    };
    NSDictionary *payload = @{
        @"email": email,
        @"PasskeyCredential": @{
          @"id": [credential.credentialID base64URLEncodedString],
          @"rawId": [credential.credentialID base64URLEncodedString],
          @"type": @"public-key",
          @"response": responseDict
         
        }
      };
  
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/login/passkey/finish"
                                queryParams:@{
                                    @"apikey": [LoginRadiusSDK apiKey],
                                }
                                       body:payload
                          completionHandler:^(NSDictionary *response, NSError *error) {
        completion(response, error);
        [self resetCurrentState];
    }];
}

#pragma mark - Autofill Login Flow

- (void)beginAutofillLoginWithPasskey:(LRAPIResponseHandler)completion {
    if (!self.currentPresentingVC) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Presentation context not set. Call setPresentationContext: first."}]);
        return;
    }
    
    
    self.currentIsRegistration = NO;
    self.currentIsAdd = NO;
    self.currentIsAutofill = YES;
    self.currentCompletion = completion;
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/login/passkey/autofill/begin"
                               queryParams:@{
                                   @"apikey": [LoginRadiusSDK apiKey],
                                   
                               }
                         completionHandler:^(NSDictionary *response, NSError *error) {
        if (error) {
            self.currentCompletion(nil, error);
            [self resetCurrentState];
            return;
        }
        
        self.currentPublicKey = response[@"LoginBeginCredential"][@"publicKey"];
        self.currentIdentifier = @"autofill";
        NSLog(@"Response of autofill passkey is %@",response);
        [self performAssertionRequest];
    }];
}

- (void)finishAutofillLoginWithPasskey:(NSDictionary *)passkey
                            completion:(LRAPIResponseHandler)completion {
    if (!self.currentPublicKey || !self.currentIdentifier) {
            completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Begin autofill login first"}]);
            [self resetCurrentState];
            return;
        }
        
        // Extract the credential from the passkey dictionary (provided by ASAuthorizationControllerDelegate)
        ASAuthorizationPlatformPublicKeyCredentialAssertion *credential = nil;
        if ([passkey[@"credential"] isKindOfClass:[ASAuthorizationPlatformPublicKeyCredentialAssertion class]]) {
            credential = passkey[@"credential"];
        }
        if (!credential) {
            completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Invalid credential"}]);
            [self resetCurrentState];
            return;
        }
        
        // Prepare the response dictionary for the finish API
        NSDictionary *responseDict = @{
            @"authenticatorData": [credential.rawAuthenticatorData base64URLEncodedString],
            @"clientDataJSON": [credential.rawClientDataJSON base64URLEncodedString],
            @"signature": [credential.signature base64URLEncodedString],
            @"userHandle": credential.userID ? [credential.userID base64URLEncodedString] : [NSNull null]
        };
    
    NSDictionary *payload = @{
            @"PasskeyCredential": @{
                @"id": [credential.credentialID base64URLEncodedString],
                @"rawId": [credential.credentialID base64URLEncodedString],
                @"response": responseDict,
                @"type": @"public-key"
            }
        };
        
        // Call the finish API to complete the autofill login
        [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/login/passkey/autofill/finish"
                                    queryParams:@{
                                        @"apikey": [LoginRadiusSDK apiKey]
                                    }
                                           body:payload
                              completionHandler:^(NSDictionary *response, NSError *error) {
            completion(response, error);
            NSLog(@"Autofill finish response: %@", response);
            [self resetCurrentState];
        }];
}

#pragma mark - Add Passkey Flow

- (void)beginAddPasskeyWithToken:(NSString *)accesstoken
                        completion:(LRAPIResponseHandler)completion {
    if (!self.currentPresentingVC) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Presentation context not set. Call setPresentationContext: first."}]);
        return;
    }
    
  
    self.currentIsRegistration = YES;
    self.currentIsAdd = YES;
    self.currentAccessToken = accesstoken;
    self.currentCompletion = completion;
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/account/register/passkey/begin"
                               queryParams:@{
                                   @"apikey": [LoginRadiusSDK apiKey],
                                   @"access_token": accesstoken
                               }
                         completionHandler:^(NSDictionary *response, NSError *error) {
        if (error) {
            self.currentCompletion(nil, error);
            [self resetCurrentState];
            return;
        }
        self.currentPublicKey = response[@"RegisterBeginCredential"][@"publicKey"];
        NSLog(@"Response of add passkey is %@",response);
        [self performRegistrationRequest];
    }];
}

- (void)finishAddPasskeyWithPasskey:(NSDictionary *)passkey
                         completion:(LRAPIResponseHandler)completion {
    if (!self.currentPublicKey || !self.currentAccessToken) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Begin add passkey first"}]);
        [self resetCurrentState];
        return;
    }
    ASAuthorizationPlatformPublicKeyCredentialRegistration *credential = nil;
    if ([passkey[@"credential"] isKindOfClass:[ASAuthorizationPlatformPublicKeyCredentialRegistration class]]) {
        credential = passkey[@"credential"];
    }
    if (!credential) {
        completion(nil, [NSError errorWithDomain:@"PasskeyAPI" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Invalid credential"}]);
        [self resetCurrentState];
        return;
    }
    
    NSDictionary *responseDict = @{
        @"clientDataJSON": [credential.rawClientDataJSON base64URLEncodedString],
        @"attestationObject": [credential.rawAttestationObject base64URLEncodedString]
    };
    NSDictionary *payload = @{
        @"id": [credential.credentialID base64URLEncodedString],
        @"rawId": [credential.credentialID base64URLEncodedString],
        @"response": responseDict,
        @"type": @"public-key"
    };
    
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/account/register/passkey/finish"
                                queryParams:@{
                                    @"apikey": [LoginRadiusSDK apiKey],
                                    @"access_token": self.currentAccessToken
                                }
                                       body:payload
                          completionHandler:^(NSDictionary *response, NSError *error) {
        completion(response, error);
        [self resetCurrentState];
    }];
}

#pragma mark - List Passkeys as it requires api secret
- (void)listPasskeys:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/account/passkey"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": access_token
                                             }
                           completionHandler:completion];
    
}


#pragma mark - Delete Passkey

- (void)deletePasskeyWithPasskeyId:(NSString *)passkeyId
                     accesstoken:(NSString *)accesstoken
               completionHandler:(LRAPIResponseHandler)completion {
    NSString *passkeyID = passkeyId ?: @"";
   
    
    [[LoginRadiusREST apiInstance] sendDELETE:[NSString stringWithFormat:@"identity/v2/auth/account/passkey/%@", passkeyId]
                                 queryParams:@{
                                     @"apikey": [LoginRadiusSDK apiKey],
                                     @"access_token":accesstoken
                                
                                 }
                                        body:@{}
                              completionHandler:completion];
}



#pragma mark - ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller
       didCompleteWithAuthorization:(ASAuthorization *)authorization {
    
    NSDictionary *passkey = nil;
    
    if (self.currentIsRegistration) {
        // Registration flow
        ASAuthorizationPlatformPublicKeyCredentialRegistration *reg =
            (ASAuthorizationPlatformPublicKeyCredentialRegistration *)authorization.credential;
        
        NSDictionary *responseDict = @{
            @"clientDataJSON": [reg.rawClientDataJSON base64URLEncodedString],
            @"attestationObject": [reg.rawAttestationObject base64URLEncodedString]
        };
        
        passkey = @{
            @"credential": reg,
            @"id": [reg.credentialID base64URLEncodedString],
            @"rawId": [reg.credentialID base64URLEncodedString],
            @"response": responseDict,
            @"type": @"public-key"
        };
        
    } else {
        // Login / assertion flow
        ASAuthorizationPlatformPublicKeyCredentialAssertion *assert =
            (ASAuthorizationPlatformPublicKeyCredentialAssertion *)authorization.credential;
        
        NSDictionary *responseDict = @{
            @"authenticatorData": [assert.rawAuthenticatorData base64URLEncodedString],
            @"clientDataJSON": [assert.rawClientDataJSON base64URLEncodedString],
            @"signature": [assert.signature base64URLEncodedString],
            @"userHandle": assert.userID ? [assert.userID base64URLEncodedString] : [NSNull null]
        };
        
        passkey = @{
            @"credential": assert,
            @"id": [assert.credentialID base64URLEncodedString],
            @"rawId": [assert.credentialID base64URLEncodedString],
            @"response": responseDict,
            @"type": @"public-key"
        };
    }
    
    // Decide which finish API to call
    if (self.currentIsAdd) {
        [self finishAddPasskeyWithPasskey:passkey completion:self.currentCompletion];
    } else if (self.currentIsAutofill) {
        [self finishAutofillLoginWithPasskey:passkey completion:self.currentCompletion];
    } else if (self.currentIsRegistration) {
        [self finishRegistrationWithPasskey:passkey completion:self.currentCompletion];
    } else {
        [self finishLoginWithPasskey:passkey completion:self.currentCompletion];
    }
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    self.currentCompletion(nil, error);
    [self resetCurrentState];
}

- (void)resetCurrentState {
    self.currentPublicKey = nil;
    self.currentRpId = nil;
    self.currentIdentifier = nil;
    self.currentAccessToken = nil;
    self.currentCompletion = nil;
    self.currentPresentingVC = nil;
    self.currentIsRegistration = NO;
    self.currentIsAdd = NO;
    self.currentIsAutofill = NO;
}

@end
