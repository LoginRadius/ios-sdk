//
//  LoginRadiusRaaSViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRaaSViewController.h"
#import "LoginRadiusSDK.h"
#import "LoginRadiusUtilities.h"

@interface LoginRadiusRaaSViewController () <UIWebViewDelegate> {
	UIWebView *_webView;
	NSString *_action;
}
@property(nonatomic, copy) LRServiceCompletionHandler handler;
@end

@implementation LoginRadiusRaaSViewController

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
	NSError *error = [NSError errorWithCode:LRErrorCodeRaaSCancelled
								description:@"User Registration Service cancelled"
							  failureReason:[NSString stringWithFormat:@"User registration with action: %@ cancelled", _action]];
	[self dismissViewControllerAnimated:YES completion:nil];
	if (self.handler) {
		self.handler(NO, error);
	}
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
			[self finishRaasAction];
		}
	} else if( [returnAction isEqualToString:@"login"] ) {
		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];
			[LoginRadiusUtilities lrSaveUserData:nil lrToken:lrtoken];
			[LoginRadiusUtilities lrSaveUserRaaSData:lrtoken APIKey:[LoginRadiusSDK apiKey]];
			[self finishRaasAction];
		}
	} else if ( [returnAction isEqualToString:@"forgotpassword"] ) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction];
		}
	} else if ( [returnAction isEqualToString:@"sociallogin"] ) {
		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];
			[LoginRadiusUtilities lrSaveUserData:nil lrToken:lrtoken];
			[LoginRadiusUtilities lrSaveUserRaaSData:lrtoken APIKey:[LoginRadiusSDK apiKey]];
			[self finishRaasAction];
		}
	}  else if ( [returnAction isEqualToString:@"emailverification"] ) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction];
		}
	} else if ( [returnAction isEqualToString:@"resetpassword"] ) {
		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction];
		}
	}
	return YES;
}

- (void) finishRaasAction {
	if (self.handler) {
		self.handler(YES, nil);
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end

