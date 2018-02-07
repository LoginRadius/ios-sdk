//
//  XLFormViewControllerExtension.m
//  ObjCDemo
//
//  Created by Thompson Sanjoto on 2017-06-09.
//  Copyright © 2017 Raviteja Ghanta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLFormViewControllerExtension.h"

@implementation XLFormViewController (XLFormViewControllerUtilities)

- (void) showAlert:(NSString *) title
           message:(NSString *) message
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    
    });
}


@end
