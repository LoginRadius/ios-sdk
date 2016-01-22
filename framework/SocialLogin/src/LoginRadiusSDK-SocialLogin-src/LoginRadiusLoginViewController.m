//
//  LoginRadiusLoginViewController.m
//  LoginRadius
//
//  Created by Lucius Yu on 2014-12-11.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import "LoginRadiusLoginViewController.h"
#import "LoginRadiusUtilities.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface LoginRadiusLoginViewController ()

@end

@implementation LoginRadiusLoginViewController

@synthesize accountStore;
@synthesize accountType;
@synthesize isConfigured;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isConfigured = false;
    
//    if( [_provider caseInsensitiveCompare:@"twitter"] == NSOrderedSame ) {
//        [self checkNativeLoginConfiguration];
//    } else {
//        [self takeActions];
//    }
    
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?apikey=%@&provider=%@&ismobile=1", _siteName, _apiKey, _provider]];
    [webView loadRequest:[NSURLRequest requestWithURL: url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark - Web View Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@"token"].location != NSNotFound && [request.URL.path isEqualToString:@"/mobile.aspx"]) {
        LoginRadiusUtilities *utility = [[LoginRadiusUtilities alloc] init];
        
        NSDictionary *parameters = [utility dictionaryWithQueryString:request.URL.query];
        NSString *token = [parameters objectForKey:@"token"];
        NSLog(@"[LR] - token: %@", token);
        if( token ) {

            
            NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
            
            BOOL userSaved = [utility lrSaveUserData:nil lrToken:token];
            BOOL userDeleted = [lrUser integerForKey:@"lrUserBlocked"];
            if(!userSaved) {
                NSLog(@"Error, something wrong with user saving process");
            }
            
            NSLog(@"Login Succeed");
            [self.delegate handleLoginResponse:true :userDeleted];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            NSLog(@" [LR] - Did not obtain valid token to redirect.");
            [self.delegate handleLoginResponse:false :false];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return YES;
    }
    return YES;
}

- (void)checkNativeLoginConfiguration {
    
    accountStore = [[ACAccountStore alloc] init];
    accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSLog(@"Twitter Native Login is granted");
            isConfigured = true;
            [self takeActions];
        }else {
            NSLog(@"Twitter Native Login is NOT granted");
            isConfigured = false;
            [self takeActions];
        }
    }];
}

- (void)takeActions {
    isConfigured = false;
    
    if (isConfigured) {
        //Exchange for LoginRadius Access Token and go to specified page
        NSString *twAccessToken = [self getNativeAccessToken];
        NSLog(@"Twitter Native Access Token is: %@", twAccessToken);
        
        NSString *url = [[NSString alloc] initWithFormat:@"https://api.loginradius.com/api/v2/access_token/twitter?key=%@&tw_access_token=%@&tw_token_secret=%@", _apiKey, twAccessToken, _twitterSecret];
        NSLog(@"%@", url);
        LoginRadiusUtilities *util = [[LoginRadiusUtilities alloc] init];
        NSMutableDictionary *resposne = [util sendSyncGetRequest:url];
        NSString *lrAccessToken = [resposne objectForKey:@"access_token"];
        NSLog(@"LoginRadius Access Token is => %@", lrAccessToken);
        BOOL isUserSaved = [util lrSaveUserData:nil lrToken:lrAccessToken];
        
        if (isUserSaved) {
            // Go to parent controller
            NSLog(@"User data succesfully saved");
        } else {
            // Error
            NSLog(@"Native Twitter => Error in saving user information");
        }
        
        
        
    } else {
        
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.hub.loginradius.com/RequestHandlor.aspx?apikey=%@&provider=%@&ismobile=1", _siteName, _apiKey, _provider]];
        NSLog(@"url is : %@", url );
        [webView loadRequest:[NSURLRequest requestWithURL: url]];
        [self.view addSubview:webView];
    }
}

- (NSString *)getNativeAccessToken {
    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
    ACAccount *twAccount = [accounts objectAtIndex:0];
    if (twAccount) {
        NSLog(@"Found twitter account");
    }
    
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
@end
