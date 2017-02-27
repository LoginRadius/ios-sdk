//
//  LRSession.m
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import "LRSession.h"
#import "NSMutableDictionary+LRMutableDictionary.h"

@implementation LRSession

- (instancetype)initWithAccessToken:(NSString*)token userProfile:(NSDictionary*)userProfile{

    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];

    [lrUser setObject:token forKey:@"lrAccessToken"];

    long lrUserBlocked = [[userProfile objectForKey:@"IsDeleted"] integerValue];

    //User is not blocked
    if(lrUserBlocked == 0) {
        [lrUser setInteger:true forKey:@"isLoggedIn"];
        [lrUser setInteger:false forKey:@"lrUserBlocked"];
    } else {
        [lrUser setInteger:true forKey:@"lrUserBlocked"];
    }

    if (![userProfile objectForKey:@"errorCode"]) {
        [lrUser setObject:[[userProfile mutableCopy] replaceNullWithBlank] forKey:@"lrUserProfile"];
    }
}

@end
