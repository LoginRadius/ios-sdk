//
//  LoginRadiusSocialLoginManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusTwitterLogin.h"
#import "LoginRadiusFacebookLogin.h"
#import "LoginRadiusWebLoginViewController.h"
#import "LoginRadiusSafariLogin.h"
#import <SafariServices/SafariServices.h>
#import "LoginRadiusREST.h"
#import "LoginRadius.h"

@interface LoginRadiusSocialLoginManager() {}
@property(nonatomic, strong) LoginRadiusTwitterLogin * twitterLogin;
@property(nonatomic, strong) LoginRadiusFacebookLogin * facebookLogin;
@property(nonatomic, strong) LoginRadiusSafariLogin * safariLogin;
@property (assign, readonly, nonatomic) BOOL isSafariLogin;
@property (assign, readonly, nonatomic) BOOL isFacebookNativeLogin;
@property BOOL EmailVerified;
@property BOOL PhoneIdVerified;
@end

@implementation LoginRadiusSocialLoginManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoginRadiusSocialLoginManager *instance;

    dispatch_once(&onceToken, ^{
        instance = [[LoginRadiusSocialLoginManager alloc] init];
    });

    return instance;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _twitterLogin = [[LoginRadiusTwitterLogin alloc] init];
        _facebookLogin = [[LoginRadiusFacebookLogin alloc] init];
        _safariLogin = [[LoginRadiusSafariLogin alloc] init];
    }
    return self;
}

#pragma mark Login Methods
-(void)loginWithProvider:(NSString*)provider
            inController:(UIViewController*)controller
       completionHandler:(LRAPIResponseHandler)handler {
   
    // Use SFSafariViewController if available by defualt. Recommended approach
    if ([SFSafariViewController class] != nil) {
        _isSafariLogin = YES;
        [self.safariLogin loginWithProvider:provider inController:controller completionHandler:handler];
        return;
    }

    // Use web login
    LoginRadiusWebLoginViewController *webVC = [[LoginRadiusWebLoginViewController alloc] initWithProvider:provider completionHandler:handler];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    [controller presentViewController:navVC animated:YES completion:nil];
}


- (void)nativeFacebookLoginWithPermissions:(NSDictionary *)params
withSocialAppName:(NSString *)socialAppName
                              inController:(UIViewController *)controller
completionHandler:(LRAPIResponseHandler)handler {
   // self.handler=handler;
    _isFacebookNativeLogin = YES;
    [self.facebookLogin loginfromViewController:controller parameters:params withSocialAppName:socialAppName handler:handler];
}

- (void)convertTwitterTokenToLRToken:(NSString *)twitterAccessToken twitterSecret:(NSString *)twitterSecret
                         withSocialAppName:(NSString *)socialAppName
                        inController:(UIViewController *)controller completionHandler:(LRAPIResponseHandler)handler {
    [self.twitterLogin getLRTokenWithTwitterToken:twitterAccessToken twitterSecret:twitterSecret withSocialAppName:socialAppName inController:controller handler:handler];
    
}

- (void)convertGoogleTokenToLRToken:(NSString *)google_token google_refresh_token:(NSString *)google_refresh_token google_client_id:(NSString *)google_client_id
                        withSocialAppName:(NSString *)socialAppName
                       inController:(UIViewController *)controller completionHandler:(LRAPIResponseHandler)handler {
    NSString *refresh_token = google_refresh_token ? google_refresh_token: @"";
    NSString *client_id = google_client_id ? google_client_id: @"";
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionaryWithDictionary:@{@"key": [LoginRadiusSDK apiKey],
    @"google_access_token" : google_token,
    @"refresh_token" : refresh_token,
    @"client_id" : client_id
    }];
    if(socialAppName && [socialAppName length]) {
        [dictParam setValue:socialAppName forKey:@"socialappname"];
    }
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/access_token/google"
                               queryParams:dictParam
                         completionHandler:^(NSDictionary *data, NSError *error) {

         handler(data, error);
        
    }];

}

- (void)convertWeChatCodeToLRToken:(NSString *)code completionHandler:(LRAPIResponseHandler)handler {
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/access_token/wechat"
                            queryParams:@{ @"key": [LoginRadiusSDK apiKey],
                                           @"code" : code
                                         }
                         completionHandler:^(NSDictionary *data, NSError *error) {
         handler(data, error);
        
    }];

}

- (void)convertAppleCodeToLRToken:(NSString *)code
                 withSocialAppName:(NSString *)socialAppName
                completionHandler:(LRAPIResponseHandler)handler {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionaryWithDictionary:@{ @"key": [LoginRadiusSDK apiKey],
      @"code" : code
    }];
   if(socialAppName && [socialAppName length]) {
        [dictParam setValue:socialAppName forKey:@"socialappname"];
    }
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/access_token/apple"
                            queryParams:dictParam
                         completionHandler:^(NSDictionary *data, NSError *error) {
         handler(data, error);
        
    }];

}


- (void)logout {
    // Only facebook native login stores sessions that we have to clear
    [self.facebookLogin logout];
}

#pragma mark Application delegate methods
- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
    [self.facebookLogin applicationLaunchedWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    BOOL canOpen = NO;


    if (_isFacebookNativeLogin)
    {
        _isFacebookNativeLogin = NO;
        canOpen = [self.facebookLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    } else if (_safariLogin)
    {
        _isSafariLogin = NO;
        canOpen = [self.safariLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }

    return canOpen;
}


@end
