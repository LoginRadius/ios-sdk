//
//  ViewController.m
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import "ViewController.h"
#import "AuthWechatManager.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)selectScene:(NSString *)title completion:(void (^)(int scene))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
   
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completion(-1);
    }]];
    [self presentViewController:alertController animated:true completion:nil];
}


- (IBAction)auth:(id)sender {
    [[AuthWechatManager shareInstance] auth: self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
