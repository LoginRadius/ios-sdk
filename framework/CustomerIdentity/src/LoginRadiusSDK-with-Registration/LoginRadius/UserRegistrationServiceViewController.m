//
//  UserRegistrationServiceViewController.m
//  LoginRadius
//
//  Created by Lucius Yu on 2015-06-18.
//  Copyright (c) 2016 LoginRadius. All rights reserved.
//

#import "UserRegistrationServiceViewController.h"
#import "LoginRadiusUtilities.h"

@implementation UserRegistrationServiceViewController
@synthesize apiKey;
@synthesize siteName;
@synthesize action;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    webView.delegate = self;
    NSString *url_address = [[NSString alloc] initWithFormat:@"http://www.deevoz.com/lrhostedtest/?apikey=%@&sitename=%@&action=%@",apiKey, siteName, action];

    //NSString *url_address = [[NSString alloc] initWithFormat:@"https://cdn.loginradius.com/hub/prod/Theme/mobile/index.html?apikey=%@&sitename=%@&action=%@",apiKey, siteName, action];
    NSLog(@"web url is %@", url_address);
    
    NSURL *url = [NSURL URLWithString:url_address];
    [webView loadRequest:[NSURLRequest requestWithURL: url]];
}

- (void)viewDidLayoutSubviews {
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    LoginRadiusUtilities *utility = [[LoginRadiusUtilities alloc] init];
    
    NSDictionary *params = [utility dictionaryWithQueryString:request.URL.query];
//    NSLog(@"Query parameters => %@", params);
    
    NSString *returnAction = [params objectForKey:@"action"];
    
    if( [returnAction isEqualToString:@"registration"]) {
        if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
            NSLog(@"registration finished");
            [self.urDelegate handleRegistrationResponse:true emailSent:true];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if( [returnAction isEqualToString:@"login"] ) {
        if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
            NSLog(@"login finished, token => %@, lr user id => %@", [params objectForKey:@"lrtoken"], [params objectForKey:@"lraccountid"]);
            
            NSString *lrtoken = [params objectForKey:@"lrtoken"];
            
            [utility lrSaveUserData:nil lrToken:lrtoken];
            [utility lrSaveUserRaaSData:lrtoken APIKey:apiKey];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if ( [returnAction isEqualToString:@"forgotpassword"] ) {
        if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
            NSLog(@"forgotpassword finished");
            [self.urDelegate handleForgotPasswordResponse:true emailSent:true];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if ( [returnAction isEqualToString:@"sociallogin"] ) {
        if ([request.URL.absoluteString rangeOfString:@"lrtoken"].location != NSNotFound) {
            NSLog(@"login finished, token => %@, lr user id => %@", [params objectForKey:@"lrtoken"], [params objectForKey:@"lraccountid"]);
            
            NSString *lrtoken = [params objectForKey:@"lrtoken"];
            
            
            [utility lrSaveUserData:nil lrToken:lrtoken];
            [utility lrSaveUserRaaSData:lrtoken APIKey:apiKey];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
//    } else if ( [returnAction isEqualToString:@"emailverification"] ) {
//        if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
//            NSLog(@"Email Verification is done");
//            [self.urDelegate handleEmailVerificationResponse:true];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else if ( [returnAction isEqualToString:@"resetpassword"] ) {
//        if ([request.URL.absoluteString rangeOfString:@"status"].location != NSNotFound) {
//            NSLog(@"Reset password is done");
//            [self.urDelegate handleResetPasswordResponse:true];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    return YES;
}

@end
