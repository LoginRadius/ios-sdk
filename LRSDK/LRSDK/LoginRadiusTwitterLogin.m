//
//  LoginRadiusTwitterLogin.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusSDK.h"
#import "IDTwitterAccountChooserViewController.h"
#import "LoginRadiusREST.h"
#import "LoginRadiusUtilities.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "OAuth+Additions.h"
#import "TWTAPIManager.h"
#import "TWTSignedRequest.h"
#import "NSDictionary+LRDictionary.h"
#import "LRErrors.h"

@interface LoginRadiusTwitterLogin()
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;
@property (nonatomic, copy) LRServiceCompletionHandler handler;

@property (nonatomic, strong) TWTAPIManager *apiManager;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) UIButton *reverseAuthBtn;

@property BOOL isConfigured;

@end

@implementation LoginRadiusTwitterLogin

@synthesize accountStore, accountType;

- (instancetype)init{

	self = [super init];
	if (self) {
		accountStore = [[ACAccountStore alloc] init];
		_apiManager = [[TWTAPIManager alloc] init];
	}
	return self;
}

+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	static dispatch_once_t onceToken;
	static LoginRadiusTwitterLogin *instance;
	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusTwitterLogin alloc] init];
	});
	return instance;
}

-(void)login:(LRServiceCompletionHandler)handler {
	self.handler = handler;
	accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
		if(granted) {
			_isConfigured = true;
			NSArray *accounts = [accountStore accountsWithAccountType:accountType];
			if ([accounts count] > 1) {
				IDTwitterAccountChooserViewController *chooser = [[IDTwitterAccountChooserViewController alloc] init];
				[chooser setTwitterAccounts: [accountStore accountsWithAccountType:accountType]];
				[chooser setCompletionHandler:^(ACAccount *twAccount) {
					// if user cancels the chooser then 'account' will be set to nil
					if (!twAccount) {
						[self finishLogin:NO withError:[LRErrors nativeTwitterLoginCancelled]];
					}
					else {
						[self takeActions:twAccount];
					}
				}];
			} else {
				[self takeActions:[accounts objectAtIndex:0]];
			}
		} else {
			[self finishLogin:NO withError:[LRErrors nativeTwitterLoginFailed]];
			_isConfigured = false;
		}
	}];
}

- (void)takeActions: (ACAccount *)twAccount {
	[_apiManager performReverseAuthForAccount:twAccount withHandler:^(NSData *responseData, NSError *error) {
		if (responseData) {
			NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
			NSDictionary * params = [NSDictionary dictionaryWithQueryString:responseStr];

			// Get loginradius access token for twitter access token
			[[LoginRadiusREST sharedInstance] callAPIEndpoint:@"api/v2/access_token/twitter"
													   method:@"GET"
													   params:@{@"key": [LoginRadiusSDK apiKey],
																@"tw_access_token" : params[@"oauth_token"],
																@"tw_token_secret":params[@"oauth_token_secret"]
																}
											completionHandler:^(NSDictionary *data, NSError *error) {
				NSString *token = [data objectForKey:@"access_token"];
				[LoginRadiusUtilities lrSaveUserData:nil lrToken:token];
				[self finishLogin:YES withError:nil];
			}];
		} else {
			[self finishLogin:NO withError:error];
		}
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
