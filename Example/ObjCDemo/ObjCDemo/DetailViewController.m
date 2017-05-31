//
//  DetailViewController.m
//  ObjCDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "DetailViewController.h"
#import <LoginRadiusSDK/LoginRadius.h>
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *email;
@property (weak, nonatomic) IBOutlet UITextView *uid;
@property (weak, nonatomic) IBOutlet UITextView *name;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];

    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSDictionary * profile =  [lrUser objectForKey:@"lrUserProfile"];
    NSString * fullname = [NSString stringWithFormat:@"%@ %@ %@", profile[@"FirstName"], profile[@"MiddleName"], profile[@"LastName"]];
    [self.name setText:fullname];
    [self.uid setText:[profile objectForKey:@"Uid"]];
    NSDictionary *email = [(NSArray*)[profile objectForKey:@"Email"] objectAtIndex:0];
    [self.email setText:[email objectForKey:@"Value"]];
}

- (IBAction)logoutPressed:(id)sender {
    /* Google Native SignIn
    [[GIDSignIn sharedInstance] signOut];
    */
    [LoginRadiusSDK logout];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
