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
@property (atomic) BOOL showNativeTwitter;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNativeTwitter = NO;
    
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
    
    [self setupForm];

}

- (void) setupForm
{
    [[[self navigationController] navigationBar] topItem].title = @"LoginRadius ObjCDemo 3.5.0 🇮🇳";
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;

    form = [XLFormDescriptor formDescriptor];

    //Basic Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@" "];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Login" rowType:XLFormRowDescriptorTypeButton title:@"Login"];
    row.action.formSelector = @selector(login);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Register" rowType:XLFormRowDescriptorTypeButton title:@"Register"];
    row.action.formSelector = @selector(registration);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ForgotPassword" rowType:XLFormRowDescriptorTypeButton title:@"Forgot Password"];
    row.action.formSelector = @selector(forgotPassword);
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"SocialLoginOnly" rowType:XLFormRowDescriptorTypeButton title:@"Social Login Only"];
    row.action.formSelector = @selector(socialLoginOnly);
    [section addFormRow:row];
    
    //end of Basic Section
    
    BOOL socialNativeLoginEnabled = (LoginRadiusSDK.enableGoogleNativeInHosted ||  LoginRadiusSDK.enableFacebookNativeInHosted || self.showNativeTwitter);
    
    if(socialNativeLoginEnabled)
    {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Native Social Login"];
        [form addFormSection:section];
        
        if([[LoginRadiusSDK sharedInstance] enableGoogleNativeInHosted])
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(showProfileController)
            name:@"userAuthenticatedFromNativeGoogle"
            object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(showNativeGoogleLogin)
            name:@"googleNative"
            object:nil];
            
            row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeGoogle" rowType:XLFormRowDescriptorTypeButton title:@"Google"];
            row.action.formSelector = @selector(showNativeGoogleLogin);
            [section addFormRow:row];
        }
        
        if([[LoginRadiusSDK sharedInstance] enableFacebookNativeInHosted])
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(showNativeFacebookLogin)
            name:@"facebookNative"
            object:nil];
            row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeFacebook" rowType:XLFormRowDescriptorTypeButton title:@"Facebook"];
            row.action.formSelector = @selector(showNativeFacebookLogin);
            [section addFormRow:row];
        }
        
        if(self.showNativeTwitter)
        {
            row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeTwitter" rowType:XLFormRowDescriptorTypeButton title:@"Twitter"];
            row.action.formSelector = @selector(showNativeTwitterLogin);
            [section addFormRow:row];
        
        }
        
    }
    
    self.form = form;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)registration {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"registration" inController:self];
}

- (void)login {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"login" inController:self];
}

- (void)forgotPassword {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"forgotpassword" inController:self];
}

- (void)socialLoginOnly {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"social" inController:self];
}

- (void)showNativeGoogleLogin {
    /* Google Native SignIn
    
    if (self.presentedViewController != nil)
    {
        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{[self showNativeGoogleLogin];}];
        return;
    }
    
    [[GIDSignIn sharedInstance] signIn];
    */
}

- (void)showNativeFacebookLogin {

    [[LoginRadiusManager sharedInstance] nativeFacebookLoginWithPermissions:@{@"facebookPermissions": @[@"public_profile",@"email"]} inController:self completionHandler:^(BOOL success, NSError *error) {
    
        if (success) {
            [self showProfileController];
        } else {
            [self showAlert:@"ERROR" message: [error localizedDescription]];
        }
    
    }];
}

- (void)showNativeTwitterLogin {
    /* Twitter Native SignIn

    [[Twitter sharedInstance] logInWithCompletion:
    ^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (session){
            [[LoginRadiusManager sharedInstance] convertTwitterTokenToLRToken:session.authToken twitterSecret:session.authTokenSecret inController:self completionHandler:^(BOOL success, NSError *error) {
                if (success){
                    [self showProfileController];
                }else if(error){
                    [self showAlert:@"ERROR" message:error.localizedDescription];
                }
            }];
        } else if (error){
            [self showAlert:@"ERROR" message:error.localizedDescription];
        }
    }];*/
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
