//
//  LRFaceIDAuth.m
//  Pods
//
//  Created by Megha Agarwal on 15/12/22.
//

#import "LRFaceIDAuth.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LRErrors.h"
#import "LoginRadiusError.h"
#import "LoginRadiusSDK.h"

@implementation LRFaceIDAuth

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LRFaceIDAuth *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[LRFaceIDAuth alloc] init];
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
                localizedReason:@"Use FaceID to Authenticate"
                          reply:^(BOOL success, NSError *error) {
            
            if (error) {
                handler(NO, error);
            }
            if (success) {
                handler(YES, nil);
            } else {
                handler(NO, [LRErrors faceIDNotDeviceOwner]);
            }
        }];
        
    } else {
        NSError *error = [LRErrors faceIDNotAvailable];
        handler(NO, error);
    }
}

@end
