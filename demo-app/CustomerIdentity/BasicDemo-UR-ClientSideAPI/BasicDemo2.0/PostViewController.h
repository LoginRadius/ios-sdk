//
//  PostViewController.h
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-15.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoginRadius/LoginRadiusServiceDelegate.h>

@interface PostViewController : UIViewController <LoginRadiusServiceDelegate> {
    NSString *titleText;
    NSString *statusText;
    NSString *token;
}
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextView *statusInput;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end
