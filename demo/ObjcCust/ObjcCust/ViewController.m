//
//  ViewController.m
//  ObjcCust
//
//  Created by Giriraj Yadav on 2020-03-19.
//  Copyright © 2020 LoginRadius. All rights reserved.
//

#import "ViewController.h"
#import <LoginRadiusSDK/LoginRadius.h>
#import "AppDelegate.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *lblNAme;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *parameter =  @{ @"Email":@"<youremailID>",
                               @"Password":@"<password>"
                               };

    [[AuthenticationAPI authInstance] loginWithPayload:parameter loginurl:nil emailtemplate:nil smstemplate:nil g_recaptcha_response:nil completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"successfully logged in %@", data);
                
                NSString *access_token= [data objectForKey:@"access_token"];
                NSDictionary *_data =[data objectForKey:@"Profile"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([_data objectForKey:@"Email"] && [[_data objectForKey:@"Email"] count]){
                        if([[[_data objectForKey:@"Email"]objectAtIndex:0] objectForKey:@"Value"])
                _lblEmail.text = [NSString stringWithFormat:@"Email : %@",[[[_data objectForKey:@"Email"]objectAtIndex:0]objectForKey:@"Value"]];
                    }
                });
                
            } else {
                NSLog(@"Error: %@", [error description]);
            }
        }];
}


@end
