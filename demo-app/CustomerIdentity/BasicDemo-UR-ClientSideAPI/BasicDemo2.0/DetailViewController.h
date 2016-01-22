//
//  DetailViewController.h
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-05.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoginRadius/LoginRadiusLoginViewController.h>
#import <LoginRadius/LoginRadiusUserRegistration.h>
#import <LoginRadius/UserRegistrationServiceViewController.h>

@interface DetailViewController : UIViewController<LoginDelegate, UserRegistrationDelegate>

// Buttons Enabled Before Login
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *fpBtn;
@property (weak, nonatomic) IBOutlet UIButton *slBtn;
@property (weak, nonatomic) IBOutlet UIButton *fbNativeBtn;

// Buttons Enabled After Login
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *linkedProfileBtn;
@property (weak, nonatomic) IBOutlet UIButton *postStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


@property (nonatomic, retain) LoginRadiusLoginViewController *loginViewController;
@property (strong) id <LoginDelegate> loginDelegate;
@property (strong) id <UserRegistrationDelegate> urDelegate;

- (IBAction)fpBtnClick:(id)sender;
- (IBAction)profileBtnClicked:(id)sender;
- (IBAction)linkedProfileBtnClicked:(id)sender;
- (IBAction)fbNativeLogin:(id)sender;
- (IBAction)logoutBtnClicked:(id)sender;
- (IBAction)socialLoginBtnClicked:(id)sender;


@end

