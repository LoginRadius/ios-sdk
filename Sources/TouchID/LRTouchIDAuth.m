//
//  LRTouchIDAuth.m
//  Pods
//
//  Created by LoginRadius Development Team on 01/03/17.
//
//

#import "LRTouchIDAuth.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginRadiusError.h"
#import "LRErrors.h"

@implementation LRTouchIDAuth

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LRTouchIDAuth *instance;

    dispatch_once(&onceToken, ^{
        instance = [[LRTouchIDAuth alloc] init];
    });

    return instance;
}

- (void)localAuthenticationWithFallbackTitle:(NSString *)localizedFallbackTitle
                                             completion:(LRServiceCompletionHandler)handler{

    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // Authenticate User
        context.localizedFallbackTitle = localizedFallbackTitle;
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Use TouchID to Authenticate"
                          reply:^(BOOL success, NSError *error) {

                              if (error) {
                                  handler(NO, error);
                              }
                              if (success) {
                                  handler(YES, nil);
                              } else {
                                  handler(NO, [LRErrors touchIDNotDeviceOwner]);
                              }
                          }];

    } else {
        NSError *error = [LRErrors touchIDNotAvailable];
        handler(NO, error);
    }
}

@end
