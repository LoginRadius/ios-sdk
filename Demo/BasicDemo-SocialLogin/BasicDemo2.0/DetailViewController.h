//
//  DetailViewController.h
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-05.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoginRadius/LoginRadiusLoginViewController.h>

@interface DetailViewController : UIViewController<LoginDelegate>


@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *postStatusBtn;
@property (weak, nonatomic) IBOutlet UIButton *fbNativeBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (nonatomic, retain) LoginRadiusLoginViewController *loginViewController;
@property (strong) id <LoginDelegate> loginDelegate;


- (IBAction)profileBtnClicked:(id)sender;
- (IBAction)postStatusBtnClicked:(id)sender;
- (IBAction)fbNativeLogin:(id)sender;
- (IBAction)logoutBtnClicked:(id)sender;


@end

