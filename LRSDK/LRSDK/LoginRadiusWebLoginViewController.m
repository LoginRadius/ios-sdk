//
//  LoginRadiusWebLoginViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSDK.h"
#import "LoginRadiusUtilities.h"

@interface LoginRadiusWebLoginViewController () <UIWebViewDelegate> {
	UIWebView * _webView;
	NSString * _provider;
}
@end

@implementation LoginRadiusWebLoginViewController

-(instancetype) initWithProvider: (NSString*) provider {
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
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?apikey=%@&provider=%@&ismobile=1", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], _provider]];
	[_webView loadRequest:[NSURLRequest requestWithURL: url]];
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

		NSDictionary *parameters = [LoginRadiusUtilities dictionaryWithQueryString:request.URL.query];
		NSString *token = [parameters objectForKey:@"token"];
		NSLog(@"[LR] - token: %@", token);
		if( token ) {

			NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
			BOOL userProfileSaved = [LoginRadiusUtilities lrSaveUserData:nil lrToken:token];

			if(!userProfileSaved) {
				NSLog(@"Error, something wrong with lrSaveUserData");
			}

			NSMutableDictionary *lrUserDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lrUserProfile"] mutableCopy];

			NSString *uid = [LoginRadiusUtilities getUidFromProfile:lrUserDict];

			//If uid exists save Raas user data
			if (uid && ![uid  isEqualToString: @""] ) {
				BOOL userLinkedProfileSaved = [LoginRadiusUtilities lrSaveUserRaaSData:token APIKey:[LoginRadiusSDK apiKey]];
				if(!userLinkedProfileSaved) {
					NSLog(@"Error, something wrong with lrSaveUserRaasData");
				}
			}

			NSLog(@"Login Succeed");
			BOOL userDeleted = [lrUser integerForKey:@"lrUserBlocked"];
			[self dismissViewControllerAnimated:YES completion:nil];
		} else {
			NSLog(@" [LR] - Did not obtain valid token to redirect.");
			[self dismissViewControllerAnimated:YES completion:nil];
		}
		return YES;
	}
	return YES;
}
@end
