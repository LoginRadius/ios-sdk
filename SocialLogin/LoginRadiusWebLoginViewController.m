//
//  LoginRadiusWebLoginViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSDK.h"
#import "NSDictionary+LRDictionary.h"
#import "LRErrors.h"
#import "ReachabilityCheck.h"
#import "LRClient.h"

@interface LoginRadiusWebLoginViewController () <UIWebViewDelegate>

@property(nonatomic, copy) NSString* provider;
@property(nonatomic, copy) NSURL * serviceURL;
@property(nonatomic, copy) LRServiceCompletionHandler handler;

@property(nonatomic, weak) UIWebView* webView;
@property(nonatomic, weak) UIView *retryView;
@property(nonatomic, weak) UILabel *retryLabel;
@property(nonatomic, weak) UIButton *retryButton;
@end

@implementation LoginRadiusWebLoginViewController

- (instancetype)initWithProvider: (NSString*) provider completionHandler:(LRServiceCompletionHandler)handler{
	self = [super init];
	if (self) {
		_provider = provider;
		_handler = handler;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    
    UIView * retryView = [[UIView alloc] initWithFrame:self.view.frame];
    retryView.backgroundColor = [UIColor whiteColor];
    retryView.hidden = YES;
    
    [self.view addSubview:webView];
    [self.view addSubview:retryView];
    [self.view bringSubviewToFront:retryView];
    
    UILabel * retryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    retryLabel.textColor = [UIColor grayColor];
    retryLabel.text = @"Please check your network connection and try again.";
    retryLabel.numberOfLines = 0;
    retryLabel.textAlignment = NSTextAlignmentCenter;
    retryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    retryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [retryView addSubview:retryLabel];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [retryButton setTitle:@"Retry" forState:UIControlStateNormal];
    [retryButton sizeToFit];
    retryButton.translatesAutoresizingMaskIntoConstraints = NO;
    [retryButton addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
    [retryView addSubview:retryButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:retryButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:retryView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:retryButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:retryView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:retryLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:retryView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:retryLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:retryView attribute:NSLayoutAttributeWidth multiplier:0.7f constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:retryLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:retryButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:-50.0f]];
    
    self.webView = webView;
    self.retryView = retryView;
    self.retryLabel = retryLabel;
    self.retryButton = retryButton;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];

	self.navigationItem.leftBarButtonItem = cancelItem;

	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?apikey=%@&provider=%@&ismobile=1", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], _provider]];
    
    self.serviceURL = url;
    [_webView loadRequest:[NSURLRequest requestWithURL: url]];
    [self startMonitoringNetwork];
}

- (void) cancelPressed {
	[self finishSocialLogin:NO withError:[LRErrors socialLoginCancelled:_provider]];
}

- (void)startMonitoringNetwork {
    ReachabilityCheck* reach = [ReachabilityCheck reachabilityWithHostname:@"cdn.loginradius.com"];
    reach.unreachableBlock = ^(ReachabilityCheck*reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.retryLabel.text = @"Please check your network connection and try again.";
            self.retryView.hidden = NO;
        });
    };
    
    [reach startNotifier];
}

- (void) retry: (id) sender {
    [self.webView stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.serviceURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    self.retryView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.retryView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.absoluteString rangeOfString:@"token"].location != NSNotFound && [request.URL.path isEqualToString:@"/mobile.aspx"]) {

		NSDictionary *parameters = [NSDictionary dictionaryWithQueryString:request.URL.query];
		NSString *token = [parameters objectForKey:@"token"];

		if( token ) {
			[[LRClient sharedInstance] getUserProfileWithAccessToken:token completionHandler:^(NSDictionary *data, NSError *error) {
				[self finishSocialLogin:YES	withError:error];
			}];

		} else {
			[self finishSocialLogin:NO withError:[LRErrors socialLoginFailed:_provider]];
		}
		return YES;
	}
	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    /* Facebook Auth fails with the following error.
        Error Domain=NSURLErrorDomain Code=-999 "(null)"
        UserInfo={NSErrorFailingURLStringKey=https://m.facebook.com/intern/common/referer_frame.php,
                    NSErrorFailingURLKey=https://m.facebook.com/intern/common/referer_frame.php}

        As per Facebook SDK, we should ignore these warnings.
        Ref: https://github.com/facebook/facebook-ios-sdk/blob/4b4bd9504d70d99d6c6b1ca670f486ac8f494f17/FBSDKCoreKit/FBSDKCoreKit/Internal/WebDialog/FBSDKWebDialogView.m#L141-L145
     */

    if (([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        return;
    }

    if (error.code == NSURLErrorTimedOut || error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNotConnectedToInternet) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        self.retryLabel.text = @"Please check your network connection and try again.";
    } else if (error.code == 101) {
        self.retryLabel.text = @"Error loading URL, check your API Key & Sitename and try again";
    }
    
    self.retryView.hidden = NO;
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
