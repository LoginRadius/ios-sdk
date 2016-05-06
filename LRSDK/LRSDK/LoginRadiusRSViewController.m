//
//  LoginRadiusRaaSViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRSViewController.h"
#import "LoginRadiusSDK.h"
#import "LoginRadiusUtilities.h"
#import "NSDictionary+LRDictionary.h"
#import "LRErrors.h"

@interface LoginRadiusRSViewController () <UIWebViewDelegate> {
	UIWebView *_webView;
	NSString *_action;
}
@property(nonatomic, copy) LRServiceCompletionHandler handler;
@end

@implementation LoginRadiusRSViewController

-(instancetype)initWithAction:(NSString *)action completionHandler:(LRServiceCompletionHandler)handler {
	self = [super init];
	if (self) {
		_action = action;
		_handler = handler;
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

	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];

	self.navigationItem.leftBarButtonItem = cancelItem;

	NSString *url_address = [[NSString alloc] initWithFormat:@"https://cdn.loginradius.com/hub/prod/Theme/mobile/index.html?apikey=%@&sitename=%@&action=%@",[LoginRadiusSDK apiKey], [LoginRadiusSDK siteName], _action];
	NSURL *url = [NSURL URLWithString:url_address];
	[_webView loadRequest:[NSURLRequest requestWithURL: url]];
}

- (void)cancelPressed {
	[self dismissViewControllerAnimated:YES completion:nil];
	if (self.handler) {
		self.handler(NO, [LRErrors serviceCancelled:_action]);
	}
}

- (void)viewDidLayoutSubviews {
	_webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	NSDictionary *params = [NSDictionary dictionaryWithQueryString:request.URL.query];
	NSString *returnAction = [params objectForKey:@"action"];

	if( [returnAction isEqualToString:@"registration"]) {

		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction:YES withError:nil];
		} else {
			[self finishRaasAction:NO withError:[LRErrors userRegistraionFailed]];
		}

	} else if( [returnAction isEqualToString:@"login"] ) {

		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];
			BOOL userSaved = [LoginRadiusUtilities lrSaveUserData:nil lrToken:lrtoken];
			if (userSaved) {
				[self finishRaasAction:YES withError:nil];
			} else {
				[self finishRaasAction:NO withError:[LRErrors userProfileError]];
			}
		} else {
			[self finishRaasAction:NO withError:[LRErrors userLoginFailed]];
		}

	} else if ( [returnAction isEqualToString:@"forgotpassword"] ) {

		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction:YES withError:nil];
		} else {
			[self finishRaasAction:NO withError:[LRErrors userForgotPasswordFailed]];
		}

	} else if ( [returnAction isEqualToString:@"sociallogin"] ) {

		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];
			BOOL userSaved = [LoginRadiusUtilities lrSaveUserData:nil lrToken:lrtoken];
			if (userSaved) {
				[self finishRaasAction:YES withError:nil];
			} else {
				[self finishRaasAction:NO withError:[LRErrors userProfileError]];
			}
		} else {
			[self finishRaasAction:NO withError:[LRErrors userSocialLoginFailed]];
		}

	}  else if ( [returnAction isEqualToString:@"emailverification"] ) {

		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction:YES withError:nil];
		} else {
			[self finishRaasAction:NO withError:[LRErrors userEmailVerificationFailed]];
		}

	} else if ( [returnAction isEqualToString:@"resetpassword"] ) {

		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction:YES withError:nil];
		} else {
			[self finishRaasAction:NO withError:[LRErrors userResetPasswordFailed]];
		}

	}

	return YES;
}

- (void) finishRaasAction:(BOOL)success withError:(NSError*)error {
	if (self.handler) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.handler(success, error);
		});
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

