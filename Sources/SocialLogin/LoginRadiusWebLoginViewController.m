//
//  LoginRadiusWebLoginViewController.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSDK.h"
#import "LRDictionary.h"
#import "LRErrors.h"
#import "ReachabilityCheck.h"
#import "LoginRadius.h"
#import <WebKit/WebKit.h>

@interface LoginRadiusWebLoginViewController () <WKNavigationDelegate>

@property(nonatomic, copy) NSString* provider;
@property(nonatomic, copy) NSURL * serviceURL;
@property(nonatomic, copy) LRAPIResponseHandler handler;
@property(nonatomic, weak) WKWebView* webView;
@property(nonatomic, weak) UIView *retryView;
@property(nonatomic, weak) UILabel *retryLabel;
@property(nonatomic, weak) UIButton *retryButton;
@end

@implementation LoginRadiusWebLoginViewController

- (instancetype)initWithProvider: (NSString*) provider completionHandler:(LRAPIResponseHandler)handler{
    self = [super init];
    if (self) {
        _provider = [provider lowercaseString];
        _handler = handler;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;


    WKWebView* webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkWebConfig];
    webView.navigationDelegate = self;
    
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
    self.provider=[_provider lowercaseString];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?apikey=%@&provider=%@&ismobile=1", [LoginRadiusSDK siteName], [LoginRadiusSDK apiKey], _provider]];
    
    self.serviceURL = url;
    [_webView loadRequest:[NSURLRequest requestWithURL: url]];
    [self startMonitoringNetwork];
}

- (void) cancelPressed {
    [self finishSocialLogin:@"" withError:[LRErrors socialLoginCancelled:_provider]];
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
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
      
           decisionHandler(WKNavigationActionPolicyAllow);

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  
   if ([webView.URL.absoluteString rangeOfString:@"token="].location != NSNotFound) {
       NSString *token;
      NSURLComponents *components = [NSURLComponents componentsWithURL:webView.URL resolvingAgainstBaseURL:NO];
       NSArray *queryItems = [components queryItems];


       for (NSURLQueryItem *item in queryItems)
       {
           if([item.name isEqualToString:@"token"])
               token = item.value;
           
       }
       if( token ) {
                  [self finishSocialLogin:token withError:nil];
    
               } else {
                   [self finishSocialLogin:@"" withError:[LRErrors socialLoginFailed:_provider]];
               }
           }

}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

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

- (void)finishSocialLogin:(NSString * )access_token withError:(NSError*) error {
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *data = [NSDictionary dictionaryWithObject:access_token forKey:@"access_token"];
            NSLog(@"test %@", [data objectForKey:@"access_token"]);
            self.handler(data, error);
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end



