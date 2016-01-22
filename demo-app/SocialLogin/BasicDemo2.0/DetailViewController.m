//
//  DetailViewController.m
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-05.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import "DetailViewController.h"
#import "LoginRadiusConfiguration.h"
#import <LoginRadius/LoginRadiusService.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize loginViewController;

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"postStatus"]) {
        return;
    }else {
        loginViewController = segue.destinationViewController;
        loginViewController.siteName = CLIENT_SITENAME;
        loginViewController.apiKey = API_KEY;
        loginViewController.twitterSecret = TW_SECRET;
        loginViewController.provider = segue.identifier;
        loginViewController.delegate = self;    
    }
    NSLog(@"Prepare for Segue: %@", segue.identifier);
}

- (void) checkStatus {
    NSLog(@"check, check");
    
    NSUserDefaults *lrUserDefault = [NSUserDefaults standardUserDefaults];
    BOOL isLoggedIn = [lrUserDefault integerForKey:@"isLoggedIn"];
    NSString *lrAccessToken = [lrUserDefault valueForKey:@"lrAccessToken"];
    NSLog(@"Access token is: %@", lrAccessToken);
    
    
    if (isLoggedIn) {
        NSLog(@"User is logged in ");
        _profileBtn.enabled = true;
        _logoutBtn.enabled = true;
        
        if (lrAccessToken && ![lrAccessToken isEqualToString:@""]) {
            _postStatusBtn.enabled = true;
        }
    } else {
        NSLog(@"User is not logged in ");
        _profileBtn.enabled = false;
        _logoutBtn.enabled = false;
        _postStatusBtn.enabled = false;
    }
}

- (IBAction)profileBtnClicked:(id)sender {
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSLog(@"User profile => %@", [lrUser objectForKey:@"lrUserProfile"]);
}

- (IBAction)fbNativeLogin:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    LoginRadiusService *lr = [[LoginRadiusService alloc] init];
    
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            //Process error
            NSLog(@"Facebook Native Login Error => %@", error);
        } else if (result.isCancelled ) {
            // Handle cancellations
            NSLog(@"User cancelled the login action");
        } else {
            if( [result.grantedPermissions containsObject:@"email"] ) {
                
                NSString *fbNativeAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
                [lr lrFbNativeLogin:API_KEY :fbNativeAccessToken];
                // Call Api to retrieve LR access token from fb access token
                [self checkStatus];
            }
        }
    }];
}

- (IBAction)logoutBtnClicked:(id)sender {

    LoginRadiusService *lrUserRegistration = [[LoginRadiusService alloc] init];
    [lrUserRegistration lrLogout];
    [self checkStatus];
}



#pragma delegate

- (void)handleLoginResponse:(BOOL)isLoggedin :(BOOL)isBlocked {
    NSLog(@"Authentication complete ..");
    [self checkStatus];
}
@end
