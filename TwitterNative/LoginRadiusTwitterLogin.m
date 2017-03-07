//
//  LoginRadiusTwitterLogin.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusSDK.h"
#import "LoginRadiusREST.h"
#import "LRClient.h"
#import "NSDictionary+LRDictionary.h"
#import "LRErrors.h"
#import "OAuthCore.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define TWT_API_ROOT                  @"https://api.twitter.com"
#define TWT_X_AUTH_MODE_KEY           @"x_auth_mode"
#define TWT_X_AUTH_MODE_REVERSE_AUTH  @"reverse_auth"
#define TWT_X_AUTH_MODE_CLIENT_AUTH   @"client_auth"
#define TWT_X_AUTH_REVERSE_PARMS      @"x_reverse_auth_parameters"
#define TWT_X_AUTH_REVERSE_TARGET     @"x_reverse_auth_target"
#define TWT_OAUTH_URL_REQUEST_TOKEN   TWT_API_ROOT "/oauth/request_token"
#define TWT_OAUTH_URL_AUTH_TOKEN      TWT_API_ROOT "/oauth/access_token"
#define TW_HTTP_HEADER_AUTHORIZATION @"Authorization"

typedef void(^TwitterAPIHandler)(NSData *data, NSError *error);
typedef void(^TWTSignedRequestHandler) (NSData *data, NSURLResponse *response, NSError *error);

@interface LoginRadiusTwitterLogin() <NSURLSessionDelegate>

@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;
@property (nonatomic, copy) LRServiceCompletionHandler handler;

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) UIButton *reverseAuthBtn;

@property BOOL isConfigured;
@property (nonatomic, strong) NSString *consumerKey;
@property (nonatomic, strong) NSString *consumerSecret;
@end

@implementation LoginRadiusTwitterLogin

@synthesize accountStore, accountType;

- (instancetype)init {

	self = [super init];
	if (self) {
		accountStore = [[ACAccountStore alloc] init];
	}
	return self;
}

- (void)loginWithConsumerKey:(NSString *)consumerKey andConumerSecret:(NSString *)consumerSecret inController:(UIViewController *)controller completion:(LRServiceCompletionHandler)handler {
    self.consumerKey = consumerKey;
    self.consumerSecret = consumerSecret;
    self.handler = handler;
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            _isConfigured = true;
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            if ([accounts count] > 1) {

                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

                for (ACAccount *account in accounts) {
                    UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"@%@", account.username] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self takeActions:account];
                    }];
                    [alertC addAction:action];
                }

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    // if user cancels
                    [self finishLogin:NO withError:[LRErrors nativeTwitterLoginCancelled]];
                }];
                [alertC addAction:cancelAction];

                [controller presentViewController:alertC animated:YES completion:nil];
            } else if ([accounts count] == 1) {
                [self takeActions:[accounts objectAtIndex:0]];
            } else {
                [self finishLogin:NO withError:[LRErrors nativeTwitterLoginNoAccount]];
            }
        } else {
            [self finishLogin:NO withError:[LRErrors nativeTwitterLoginFailed]];
            _isConfigured = false;
        }
    }];
}

- (void)takeActions: (ACAccount *)twAccount {
	[self performReverseAuthForAccount:twAccount withHandler:^(NSData *responseData, NSError *error) {
		if (responseData) {
			NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
			NSDictionary * params = [NSDictionary dictionaryWithQueryString:responseStr];

			// Get loginradius access token for twitter access token
            [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/access_token/twitter"
                                          queryParams:@{@"key": [LoginRadiusSDK apiKey],
                                                        @"tw_access_token" : params[@"oauth_token"],
                                                        @"tw_token_secret":params[@"oauth_token_secret"]
                                                        }
											completionHandler:^(NSDictionary *data, NSError *error) {
				NSString *token = [data objectForKey:@"access_token"];
				[[LRClient sharedInstance] getUserProfileWithAccessToken:token completionHandler:^(NSDictionary *data, NSError *error) {
					[self finishLogin:YES withError:error];
				}];
			}];
		} else {
			[self finishLogin:NO withError:error];
		}
	}];
}


- (void)performReverseAuthForAccount:(ACAccount *)account withHandler:(TwitterAPIHandler)handler {
    [self getAuthorizationHeader:^(NSData *data, NSError *error) {
        if (!data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, error);
            });
        }
        else {
            NSString *signedReverseAuthSignature = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self getTokens:account signature:signedReverseAuthSignature andHandler:^(NSData *responseData, NSError *error2) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(responseData, error2);
                });
            }];
        }
    }];
}

- (void)getAuthorizationHeader:(TwitterAPIHandler)completion {
    NSURL *url = [NSURL URLWithString:TWT_OAUTH_URL_REQUEST_TOKEN];
    NSDictionary *params = @{TWT_X_AUTH_MODE_KEY: TWT_X_AUTH_MODE_REVERSE_AUTH};
    NSMutableString *paramsAsString = [[NSMutableString alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:
     ^(id key, id obj, BOOL *stop) {
         [paramsAsString appendFormat:@"%@=%@&", key, obj];
     }];
    NSData *bodyData = [paramsAsString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorizationHeader = OAuthorizationHeader(url, @"POST", bodyData, self.consumerKey, self.consumerSecret, nil, nil);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:authorizationHeader forHTTPHeaderField:TW_HTTP_HEADER_AUTHORIZATION];
    request.HTTPBody = bodyData;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(data, error);
        });
    }];

    [postDataTask resume];
}

- (void)getTokens:(ACAccount *)account signature:(NSString *)signedReverseAuthSignature andHandler:(TwitterAPIHandler)completion {
    NSDictionary *params = @{
                             TWT_X_AUTH_REVERSE_TARGET: self.consumerKey,
                             TWT_X_AUTH_REVERSE_PARMS: signedReverseAuthSignature
                            };
    NSURL *authTokenURL = [NSURL URLWithString:TWT_OAUTH_URL_AUTH_TOKEN];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:authTokenURL parameters:params];
    request.account = account;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(responseData, error);
        });
    }];
}

- (void)finishLogin:(BOOL) success withError:(NSError*) error {
	if (self.handler) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.handler(success, error);
		});
	}
}

@end
