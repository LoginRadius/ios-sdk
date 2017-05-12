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

- (IBAction)loginWithTwitter:(id)sender {
    [[LoginRadiusRegistrationManager sharedInstance] loginWithProvider:@"twitter" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in with twitter");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (IBAction)loginWithFacebook:(id)sender {
    [[LoginRadiusRegistrationManager sharedInstance] loginWithProvider:@"facebook" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in with facebook");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (IBAction)loginWithLinkedin:(id)sender {
    [[LoginRadiusRegistrationManager sharedInstance] loginWithProvider:@"linkedin" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in with linkedin");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (IBAction)registerWithEmail:(id)sender {
    [[LoginRadiusRegistrationManager sharedInstance] registrationWithAction:@"registration" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully registered");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (IBAction)loginWithEmail:(id)sender {
    [[LoginRadiusRegistrationManager sharedInstance] registrationWithAction:@"login" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (void) showProfileController {
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSString * access_token =  [lrUser objectForKey:@"lrAccessToken"];

    if (access_token) {
        [self performSegueWithIdentifier:@"profile" sender:self];
    }
}

@end
