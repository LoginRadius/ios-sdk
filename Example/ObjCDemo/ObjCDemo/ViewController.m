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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerWithEmail:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"registration" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully registered");
            [self showProfileController];
        } else {
            [self showAlert:@"ERROR" message:[error localizedDescription]];
        }
    }];
}

- (IBAction)loginWithEmail:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"login" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in");
            [self showProfileController];
        } else {
            [self showAlert:@"ERROR" message:[error localizedDescription]];
        }
    }];
}

- (IBAction)forgotPassword:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"forgotpassword" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"forgot password success");
            [self showAlert:@"SUCCESS" message:@"Forgot Password Requested, check your email inbox to reset"];
        } else {
            [self showAlert:@"ERROR" message:[error localizedDescription]];
        }
    }];
}

- (IBAction)socialLoginOnly:(id)sender {
    [[LoginRadiusManager sharedInstance] registrationWithAction:@"social" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in");
            [self showProfileController];
        } else {
            [self showAlert:@"ERROR" message:[error localizedDescription]];
        }
    }];
}

- (void) showProfileController {
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

@end
