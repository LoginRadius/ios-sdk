//
//  PostViewController.m
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-15.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import "PostViewController.h"
#import <LoginRadius/LoginRadiusService.h>

@interface PostViewController () <UITextViewDelegate>
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Post Status" style:UIBarButtonItemStylePlain target:self action:@selector(postStatus)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    
    self.statusInput.delegate = self;
    self.statusInput.layer.cornerRadius=8.0f;
    self.statusInput.layer.masksToBounds=YES;
    self.statusInput.layer.borderColor=[[UIColor blueColor]CGColor];
    self.statusInput.layer.borderWidth= 1.0f;
    self.statusInput.text = @"your status...";
    self.statusInput.textColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"your status..."]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor];
    }
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"your status...";
        textView.textColor = [UIColor lightGrayColor];
    }
    
    [textView resignFirstResponder];
}

- (void)postStatus {
    titleText = self.titleInput.text;
    statusText = self.statusInput.text;
    
    NSUserDefaults *loginradiusUserData = [NSUserDefaults standardUserDefaults];
    token = [loginradiusUserData stringForKey:@"token"];
    NSLog(@"Prepare for post => title=%@, status=%@, token=%@", titleText, statusText, token);
    
    LoginRadiusService *service = [[LoginRadiusService alloc] init];
    service.delegate = self;

    [service loginradiusPostStatus:titleText description:statusText];
}

- (void)LoginRadiusPostStatusSuccess: (BOOL)statusWall {
    if( statusWall ) {
        NSLog(@" Post Status Succeed !! ");
    } else {
        NSLog(@" Post Status Failed, please refer the Log Message ");
    }
}

@end
