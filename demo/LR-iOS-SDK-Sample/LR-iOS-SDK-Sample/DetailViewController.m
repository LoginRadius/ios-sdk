//
//  DetailViewController.m
//  LR-iOS-SDK-Sample
//
//  Copyright © 2016 LR. All rights reserved.
//

#import "DetailViewController.h"
#import <LRSDK/LRSDK.h>


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *name;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
	NSDictionary * profile =  [lrUser objectForKey:@"lrUserProfile"];
	NSString * fullname = [NSString stringWithFormat:@"%@ %@ %@", profile[@"FirstName"], profile[@"MiddleName"], profile[@"LastName"]];
	[self.name setText:fullname];
}

- (IBAction)logoutPressed:(id)sender {
	[LoginRadiusSDK logout];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
