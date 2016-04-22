//
//  LoginRadiusRaaSViewController.m
//  LR-iOS-SDK-Sample
//
//  Created by Raviteja Ghanta on 15/04/16.
//  Copyright © 2016 LR. All rights reserved.
//

#import "LoginRadiusRaaSViewController.h"
#import "LoginRadiusSDK.h"
#import "LoginRadiusUtilities.h"

@interface LoginRadiusRaaSViewController () <UIWebViewDelegate> {
	UIWebView *_webView;
	NSString *_action;
}
@property (weak, nonatomic)	UIButton *closeButton;

@end

@implementation LoginRadiusRaaSViewController

-(instancetype)initWithAction:(NSString *)action {
	self = [super init];
	if (self) {
		_action = action;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	_webView = [[UIWebView alloc] initWithFrame:self.view.frame];
	_webView.scalesPageToFit = YES;
	_webView.delegate = self;
	[self.view addSubview:_webView];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSString *url_address = [[NSString alloc] initWithFormat:@"https://cdn.loginradius.com/hub/prod/Theme/mobile/index.html?apikey=%@&sitename=%@&action=%@",[LoginRadiusSDK apiKey], [LoginRadiusSDK siteName], _action];
	NSURL *url = [NSURL URLWithString:url_address];
	[_webView loadRequest:[NSURLRequest requestWithURL: url]];
}

- (void)viewDidLayoutSubviews {
	_webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	NSDictionary *params = [LoginRadiusUtilities dictionaryWithQueryString:request.URL.query];
	NSString *returnAction = [params objectForKey:@"action"];

	if( [returnAction isEqualToString:@"registration"]) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			NSLog(@"registration finished");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	} else if( [returnAction isEqualToString:@"login"] ) {
		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSLog(@"login finished, token => %@, lr user id => %@", [params objectForKey:@"lrtoken"], [params objectForKey:@"lraccountid"]);

			NSString *lrtoken = [params objectForKey:@"lrtoken"];

			[LoginRadiusUtilities lrSaveUserData:nil lrToken:lrtoken];
			[LoginRadiusUtilities lrSaveUserRaaSData:lrtoken APIKey:[LoginRadiusSDK apiKey]];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	} else if ( [returnAction isEqualToString:@"forgotpassword"] ) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			NSLog(@"forgotpassword finished");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	} else if ( [returnAction isEqualToString:@"sociallogin"] ) {
		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSLog(@"login finished, token => %@, lr user id => %@", [params objectForKey:@"lrtoken"], [params objectForKey:@"lraccountid"]);

			NSString *lrtoken = [params objectForKey:@"lrtoken"];

			[LoginRadiusUtilities lrSaveUserData:nil lrToken:lrtoken];
			[LoginRadiusUtilities lrSaveUserRaaSData:lrtoken APIKey:[LoginRadiusSDK apiKey]];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}  else if ( [returnAction isEqualToString:@"emailverification"] ) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			NSLog(@"Email Verification is done");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	} else if ( [returnAction isEqualToString:@"resetpassword"] ) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			NSLog(@"Reset password is done");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}
	return YES;
}

@end

