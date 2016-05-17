//
//  ViewController.m
//  LR-iOS-SDK-Sample
//
//  Copyright © 2016 LR. All rights reserved.
//

#import "ViewController.h"
#import <LRSDK/LRSDK.h>
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)loginWithTwitter:(id)sender {
	[LoginRadiusSDK socialLoginWithProvider:@"twitter" parameters:nil inController:self completionHandler:^(BOOL success, NSError *error) {
		if (success) {
			NSLog(@"successfully logged in with twitter");
			[self showProfileController];
		} else {
			NSLog(@"Error: %@", [error description]);
		}
	}];
}

- (IBAction)loginWithFacebook:(id)sender {
	[LoginRadiusSDK socialLoginWithProvider:@"facebook" parameters:@{@"facebookPermissions": @[@"public_profile", @"user_likes"]} inController:self completionHandler:^(BOOL success, NSError *error) {
		if (success) {
			NSLog(@"successfully logged in with facebook");
			[self showProfileController];
		} else {
			NSLog(@"Error: %@", [error description]);
		}
	}];
}

- (IBAction)loginWithLinkedin:(id)sender {
	[LoginRadiusSDK socialLoginWithProvider:@"linkedin" parameters:nil inController:self completionHandler:^(BOOL success, NSError *error) {
		if (success) {
			NSLog(@"successfully lo gged in with linkedin");
			[self showProfileController];
		} else {
			NSLog(@"Error: %@", [error description]);
		}
	}];
}

- (IBAction)registerWithEmail:(id)sender {
	[LoginRadiusSDK registrationServiceWithAction:@"social" inController:self completionHandler:^(BOOL success, NSError *error) {
		if (success) {
			NSLog(@"successfully registered");
			[self showProfileController];
		} else {
			NSLog(@"Error: %@", [error description]);
		}
	}];
}

- (IBAction)loginWithEmail:(id)sender {
	[LoginRadiusSDK registrationServiceWithAction:@"login" inController:self completionHandler:^(BOOL success, NSError *error) {
		if (success) {
			NSLog(@"successfully logged in");
			[self showProfileController];
		} else {
			NSLog(@"Error: %@", [error description]);
		}
	}];
}

- (void) showProfileController {
		[self performSegueWithIdentifier:@"profile" sender:self];
}

@end
