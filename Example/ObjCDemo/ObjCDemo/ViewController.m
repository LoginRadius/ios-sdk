//
//  ViewController.m
//  ObjCDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "ViewController.h"
#import <LoginRadiusSDK/LoginRadius.h>
#import "DetailViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *googleNativeButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookNativeButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Check if already login
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSInteger profile =  [lrUser integerForKey:@"isLoggedIn"];
    if (profile) {
            [self performSegueWithIdentifier:@"profile" sender:self];
    }
    /* Google Native SignIn
    [GIDSignIn sharedInstance].uiDelegate = self;
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(receiveRegistration:)
    name:LoginRadiusRegistrationEvent
    object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(receiveLogin:)
    name:LoginRadiusLoginEvent
    object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(receiveForgotPassword:)
    name:LoginRadiusForgotPasswordEvent
    object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(receiveSocialLogin:)
    name:LoginRadiusSocialLoginEvent
    object:nil];
    
    if([[LoginRadiusSDK sharedInstance] enableGoogleNativeInHosted])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(showProfileController)
        name:@"userAuthenticatedFromNativeGoogle"
        object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(showNativeGoogleLogin:)
        name:@"googleNative"
        object:nil];
        
        _googleNativeButton.hidden = NO;
    }
    
    if([[LoginRadiusSDK sharedInstance] enableFacebookNativeInHosted])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(showNativeGoogleLogin:)
        name:@"facebookNative"
        object:nil];
        
        _facebookNativeButton.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registration:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"registration" inController:self];
}

- (IBAction)login:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"login" inController:self];
}

- (IBAction)forgotPassword:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"forgotpassword" inController:self];
}

- (IBAction)socialLoginOnly:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"social" inController:self];
}

- (IBAction)showNativeGoogleLogin:(id)sender {
    /* Google Native SignIn
    [[GIDSignIn sharedInstance] signIn];
    
    if (self.presentedViewController != nil)
    {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{[self showNativeGoogleLogin:self];}];
        return;
    }
    
    [[GIDSignIn sharedInstance] signIn];
    */
}

- (IBAction)showNativeFacebookLogin:(id)sender {

    [[LoginRadiusManager sharedInstance] nativeFacebookLoginWithPermissions:@{@"facebookPermissions": @[@"public_profile"]} inController:self completionHandler:^(BOOL success, NSError *error) {
    
        if (success) {
            [self showProfileController];
        } else {
            [self showAlert:@"ERROR" message: [error localizedDescription]];
        }
    
    }];
}

- (void) receiveRegistration:(NSNotification *) notification
{
    if([[notification userInfo][@"error"] isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)[notification userInfo][@"error"];
        [self showAlert:@"ERROR" message: [error localizedDescription]];
    }else
    {
        NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
        NSInteger profile =  [lrUser integerForKey:@"isLoggedIn"];
        if (profile) {
            [self showProfileController];
        }else{
            [self showAlert:@"SUCCESS" message: @"Registration Successful, check your email for verification"];
        }
    }
}

- (void) receiveLogin:(NSNotification *) notification
{
    if([[notification userInfo][@"error"] isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)[notification userInfo][@"error"];
        [self showAlert:@"ERROR" message: [error localizedDescription]];
    }else
    {
        [self showProfileController];
    }
}

- (void) receiveForgotPassword:(NSNotification *) notification
{
    if([[notification userInfo][@"error"] isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)[notification userInfo][@"error"];
        [self showAlert:@"ERROR" message: [error localizedDescription]];
    }else
    {
        [self showAlert:@"SUCCESS" message: @"Forgot password link send to your email id, please reset your password"];
    }
}

- (void) receiveSocialLogin:(NSNotification *) notification
{
    if([[notification userInfo][@"error"] isKindOfClass:[NSError class]])
    {
        NSError *error = (NSError *)[notification userInfo][@"error"];
        [self showAlert:@"ERROR" message: [error localizedDescription]];
    }else
    {
        [self showProfileController];
    }
}


- (void) showProfileController {

    if (self.presentedViewController != nil)
    {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{[self showProfileController];}];
        return;
    }

    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSString * access_token =  [lrUser objectForKey:@"lrAccessToken"];

    if (access_token) {
        [self performSegueWithIdentifier:@"profile" sender:self];
    }else{
        [self showAlert:@"Not Authenticated" message:@"Login Radius Access Token is missing"];
    }
}

- (void) showAlert : (NSString*) title
            message: (NSString*) message
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:title
        message:message
        preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
