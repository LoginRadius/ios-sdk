//
//  LoginRadiusRaaSViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRSViewController.h"
#import "LoginRadiusSDK.h"
#import "LRClient.h"
#import "NSDictionary+LRDictionary.h"
#import "LRErrors.h"
#import "ReachabilityCheck.h"

@interface LoginRadiusRSViewController () <UIWebViewDelegate>

@property(nonatomic, copy) NSString * action;
@property(nonatomic, copy) NSURL * serviceURL;
@property(nonatomic, weak) UIWebView* webView;
@property(nonatomic, weak) UIView *retryView;
@property(nonatomic, weak) UILabel *retryLabel;
@property(nonatomic, weak) UIButton *retryButton;
@end

@implementation LoginRadiusRSViewController

-(instancetype)initWithAction:(NSString *)action {
    self = [super init];
	if (self) {
		_action = action;
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
    [self showActivityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];


	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];

	self.navigationItem.leftBarButtonItem = cancelItem;
    NSString *url_address;

    // Base version
    NSString *baseUrl = [[LoginRadiusSDK sharedInstance] hostedPageURL];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"action": self.action,
                                                                                  @"sitename": [LoginRadiusSDK siteName],
                                                                                  @"apikey": [LoginRadiusSDK apiKey]
                                                                                  }];
    if ([LoginRadiusSDK v2RecaptchaSiteKey]) {
        [params setObject:[LoginRadiusSDK v2RecaptchaSiteKey] forKey:@"recaptchakey"];
    }

    NSString *urlParams = [[params copy] queryString];
    url_address = [[NSString alloc] initWithFormat:@"%@%@", baseUrl, urlParams];

    NSURL *url = [NSURL URLWithString:url_address];
    self.serviceURL = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL: self.serviceURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5]];
    [self startMonitoringNetwork];

}

- (void)cancelPressed {
	[self finishRaasAction:@"usercancelled" withError:[LRErrors serviceCancelled]];
}

- (void)startMonitoringNetwork {
    ReachabilityCheck* reach = [ReachabilityCheck reachabilityWithHostname:[[LoginRadiusSDK sharedInstance] hostedPageURL]];
    
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

- (void)viewDidLayoutSubviews {
	self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.retryView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	NSDictionary *params = [NSDictionary dictionaryWithQueryString:request.URL.query];
	NSString *returnAction = [params objectForKey:@"action"];

	if( [returnAction isEqualToString:@"registration"]) {

		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction:returnAction withError:nil];
		}
	} else if( [returnAction isEqualToString:@"login"] ) {

		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];
            if (lrtoken) {
                [self showActivityIndicator];
                [[LRClient sharedInstance] getUserProfileWithAccessToken:lrtoken completionHandler:^(NSDictionary *data, NSError *error) {
                    [self hideActivityIndicator];
                    [self finishRaasAction:returnAction	withError:error];
                }];

            } else {
                [self finishRaasAction:returnAction withError:[LRErrors userProfileError]];
            }
		}

	} else if ( [returnAction isEqualToString:@"forgotpassword"] ) {

		if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
			[self finishRaasAction:returnAction withError:nil];
		}

	} else if ( [returnAction isEqualToString:@"sociallogin"] || [returnAction isEqualToString:@"social"]) {

		if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
			NSString *lrtoken = [params objectForKey:@"lrtoken"];

            if (lrtoken) {
                [self showActivityIndicator];
                [[LRClient sharedInstance] getUserProfileWithAccessToken:lrtoken completionHandler:^(NSDictionary *data, NSError *error) {
                    [self hideActivityIndicator];
                    [self finishRaasAction:@"social" withError:error];
                }];
            } else {
                [self finishRaasAction:@"social" withError:[LRErrors userProfileError]];
            }
		}

	}  else {
    
        [self finishRaasAction:returnAction withError:[LRErrors unsupportedAction]];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideActivityIndicator];
}

- (void)finishRaasAction:(NSString*)action withError:(NSError*) error {
    [self dismissViewControllerAnimated:YES completion: ^{
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
        
        [[NSNotificationCenter defaultCenter]
          postNotificationName:[NSString stringWithFormat:@"lr-%@", action]
          object:self
          userInfo: userInfo];
    }];
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.color = self.navigationController.navigationBar.tintColor;
    [indicator startAnimating];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:indicator] animated:YES];
}

- (void)hideActivityIndicator {
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
}
@end

