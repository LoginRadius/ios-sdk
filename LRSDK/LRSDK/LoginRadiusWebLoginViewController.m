//
//  LoginRadiusWebLoginViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSDK.h"
#import "LoginRadiusUtilities.h"
#import "NSDictionary+LRDictionary.h"
#import "LRErrors.h"

@interface LoginRadiusWebLoginViewController () <UIWebViewDelegate> {
	UIWebView * _webView;
	NSString * _provider;
}
@property(nonatomic, copy) LRServiceCompletionHandler handler;
@end

@implementation LoginRadiusWebLoginViewController

- (instancetype)initWithProvider: (NSString*) provider completionHandler:(LRServiceCompletionHandler)handler{
	self = [super init];
	if (self) {
		_provider = provider;
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

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?apikey=%@&provider=%@&ismobile=1", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], _provider]];
	[_webView loadRequest:[NSURLRequest requestWithURL: url]];
}

- (void) cancelPressed {
	[self finishSocialLogin:NO withError:[LRErrors socialLoginCancelled:_provider]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
	_webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.absoluteString rangeOfString:@"token"].location != NSNotFound && [request.URL.path isEqualToString:@"/mobile.aspx"]) {

		NSDictionary *parameters = [NSDictionary dictionaryWithQueryString:request.URL.query];
		NSString *token = [parameters objectForKey:@"token"];

		if( token ) {
			[LoginRadiusUtilities lrSaveUserData:nil lrToken:token];
			[self finishSocialLogin:YES	withError:nil];
		} else {
			[self finishSocialLogin:NO withError:[LRErrors socialLoginFailed:_provider]];
		}
		return YES;
	}
	return YES;
}

- (void)finishSocialLogin:(BOOL)success withError:(NSError*) error {
	if (self.handler) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.handler(success, error);
		});
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
