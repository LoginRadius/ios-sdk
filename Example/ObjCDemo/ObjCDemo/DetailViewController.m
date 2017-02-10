//
//  DetailViewController.m
//  ObjCDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 Raviteja Ghanta. All rights reserved.
//

#import "DetailViewController.h"
#import <LoginRadiusSDK/LoginRadius.h>
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *name;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];

    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSDictionary * profile =  [lrUser objectForKey:@"lrUserProfile"];
    NSString * access_token =  [lrUser objectForKey:@"lrAccessToken"];
    NSString * fullname = [NSString stringWithFormat:@"%@ %@ %@", profile[@"FirstName"], profile[@"MiddleName"], profile[@"LastName"]];
    [self.name setText:fullname];

    [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/company"
                                  queryParams:@{
                                                @"access_token": access_token
                                               }
                            completionHandler:^(NSDictionary *data, NSError *error) {
                                    NSLog(@"error %@  data %@", error, data);
                            }];
}

- (IBAction)logoutPressed:(id)sender {
    [LoginRadiusSDK logout];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
