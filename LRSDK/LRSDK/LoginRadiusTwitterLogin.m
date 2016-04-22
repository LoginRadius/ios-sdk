//
//  LoginRadiusTwitterLogin.m
//  LoginRadius
//
//  Created by Raviteja Ghanta on 13/04/16.
//  Copyright © 2016 LoginRadius. All rights reserved.
//

#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusSDK.h"
#import "IDTwitterAccountChooserViewController.h"
#import "LoginRadiusREST.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface LoginRadiusTwitterLogin()
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccountType *accountType;
@property BOOL isConfigured;

@end

@implementation LoginRadiusTwitterLogin

@synthesize accountStore, accountType;

+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
	static dispatch_once_t onceToken;
	static LoginRadiusTwitterLogin *instance;
	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusTwitterLogin alloc] init];
	});
	return instance;
}

-(void)login:(loginResult)handler {
	accountStore = [[ACAccountStore alloc] init];
	accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
		if(granted) {
			NSLog(@"Twitter Native Login is granted");
			_isConfigured = true;
			NSArray *accounts = [accountStore accountsWithAccountType:accountType];
			if ([accounts count] > 1) {
				IDTwitterAccountChooserViewController *chooser = [[IDTwitterAccountChooserViewController alloc] init];
				[chooser setTwitterAccounts: [accountStore accountsWithAccountType:accountType]];
				[chooser setCompletionHandler:^(ACAccount *twAccount) {
					// if user cancels the chooser then 'account' will be set to nil
					if (!twAccount) {
						NSLog(@"Native twiiter user cancelled login");
					}
					else {
						[self takeActions:twAccount completionHandler: handler];
					}
				}];
			} else {
				[self takeActions:[accounts objectAtIndex:0] completionHandler: handler];
			}
		} else {
			NSLog(@"Twitter Native Login is NOT granted");
			_isConfigured = false;
		}
	}];
}

- (NSString *)getNativeAccessToken: (ACAccount *)twAccount {
	NSString *username = [[NSString alloc] init];

	SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:username forKey:@"screen_name"]];
	[twitterInfoRequest setAccount:twAccount];

	NSURLRequest * reqTemp = [twitterInfoRequest preparedURLRequest];
	NSDictionary * dictHeaders = [reqTemp allHTTPHeaderFields];

	NSString * authString = dictHeaders[@"Authorization"];
	NSArray * arrayAuth = [authString componentsSeparatedByString:@","];
	NSString * accessToken;
	for( NSString * val in arrayAuth ) {
		if( [val rangeOfString:@"oauth_token"].length > 0 ) {
			accessToken =
			[val stringByReplacingOccurrencesOfString:@"\""
										   withString:@""];
			accessToken =
			[accessToken stringByReplacingOccurrencesOfString:@"oauth_token="
												   withString:@""];

			NSLog(@"Accesstoken is %@", accessToken);
			return accessToken;
		}
	}

	return @"Error, can not get Twitter Native Access Token";
}

- (void)takeActions: (ACAccount *)twAccount completionHandler: (loginResult)handler{
	if (_isConfigured) {
		//Exchange for LoginRadius Access Token and go to specified page
		NSString *twAccessToken = [self getNativeAccessToken:twAccount];
		NSLog(@"Twitter Native Access Token is: %@", twAccessToken);

		// Get loginradius access token for twitter access token 
	} else {
		
	}
}

@end
