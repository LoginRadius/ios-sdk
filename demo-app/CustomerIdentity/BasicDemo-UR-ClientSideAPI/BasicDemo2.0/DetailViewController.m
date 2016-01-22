//
//  DetailViewController.m
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-05.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import "DetailViewController.h"
#import "LoginRadiusConfiguration.h"
#import <LoginRadius/LoginRadius.h>
//#import <LoginRadius/LoginRadiusUserRegistration.h>
//#import <LoginRadius/UserRegistrationServiceViewController.h>
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

    
    if ([segue.identifier isEqualToString:@"register"]) {
        UserRegistrationServiceViewController *ur = [segue destinationViewController];
        ur.apiKey = API_KEY;
        ur.siteName = CLIENT_SITENAME;
        ur.action = @"registration";
        ur.urDelegate = self;
//        ur = segue.destinationViewController;

    }else if ([segue.identifier isEqualToString:@"login"]) {
        UserRegistrationServiceViewController *ur = [segue destinationViewController];
        ur.apiKey = API_KEY;
        ur.siteName = CLIENT_SITENAME;
        ur.action = @"login";
//        ur = segue.destinationViewController;

    }else if ([segue.identifier isEqualToString:@"postStatus"]) {
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
    BOOL isblocked = [lrUserDefault integerForKey:@"lrUserBlocked"];
    if (isblocked == TRUE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account is blocked"
                                                        message:@"This account is blocked, please contact us to solve the issue."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    BOOL isLoggedIn = [lrUserDefault integerForKey:@"isLoggedIn"];
    NSString *lrAccessToken = [lrUserDefault valueForKey:@"lrAccessToken"];
    NSLog(@"Access token is: %@", lrAccessToken);
    
    
    if (isLoggedIn) {
        NSLog(@"User is logged in ");
        
        _profileBtn.enabled = true;
        _linkedProfileBtn.enabled = true;
        _logoutBtn.enabled = true;
        _postStatusBtn.enabled = true;
        
        
        _registerBtn.enabled = false;
        _loginBtn.enabled = false;
        _fpBtn.enabled = false;
        _slBtn.enabled = false;
        _fbNativeBtn = false;
        
        if (lrAccessToken && ![lrAccessToken isEqualToString:@""]) {
            _postStatusBtn.enabled = true;
        }
    } else {
        NSLog(@"User is not logged in ");
        _registerBtn.enabled = true;
        _loginBtn.enabled = true;
        _fpBtn.enabled = true;
        _slBtn.enabled = true;
        _fbNativeBtn.enabled = true;
        
        _profileBtn.enabled = false;
        _linkedProfileBtn.enabled = false;
        _logoutBtn.enabled = false;
        _postStatusBtn.enabled = false;
    }
}

- (IBAction)profileBtnClicked:(id)sender {
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSLog(@"User profile => %@", [lrUser objectForKey:@"lrUserProfile"]);
}

- (IBAction)linkedProfileBtnClicked:(id)sender {
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSLog(@"User profile => %@", [lrUser objectForKey:@"lrUserLinkedProfile"]);
}

- (IBAction)fbNativeLogin:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    LoginRadiusUserRegistration *lr = [[LoginRadiusUserRegistration alloc] init];
    
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

- (IBAction)fpBtnClick:(id)sender {
    NSLog(@"I forgot my password");
    UIStoryboard * storyboard = self.storyboard;
    UserRegistrationServiceViewController * ur = [storyboard instantiateViewControllerWithIdentifier:@"UserRegistrationServiceViewController"];
    ur.apiKey = API_KEY;
    ur.siteName = CLIENT_SITENAME;
    ur.action = @"forgotpassword";
    ur.urDelegate = self;
    [self.navigationController pushViewController:ur animated:YES];
}

- (IBAction)logoutBtnClicked:(id)sender {

    LoginRadiusUserRegistration *lrUserRegistration = [[LoginRadiusUserRegistration alloc] init];
    [lrUserRegistration lrLogout];
    [self checkStatus];
}

- (IBAction)socialLoginBtnClicked:(id)sender {
    NSLog(@"Social Login");
    UIStoryboard * storyboard = self.storyboard;
    UserRegistrationServiceViewController * ur = [storyboard instantiateViewControllerWithIdentifier:@"UserRegistrationServiceViewController"];
    ur.apiKey = API_KEY;
    ur.siteName = CLIENT_SITENAME;
    ur.action = @"social";
    //    [self presentViewController:ur animated:YES completion:nil];
    [self.navigationController pushViewController:ur animated:YES];
}




#pragma delegate

- (void)handleLoginResponse:(BOOL)isLoggedin :(BOOL)isBlocked {
    NSLog(@"You are fine now...");
    [self checkStatus];
}

- (void)handleRegistrationResponse:(BOOL)status emailSent:(BOOL)sent {
    NSLog(@"Handle the call back of Registration");
    if (status == true && sent == true) {
        NSLog(@"An email has been sent to your email address, please verify your account");
    }
}

- (void)handleForgotPasswordResponse:(BOOL)status emailSent:(BOOL)sent {
    NSLog(@"Handle the call back of Forgot Password");
    if (status == true && sent == true) {
        NSLog(@"An email has been sent to your email address, you can reset your password now");
    }
}

@end
