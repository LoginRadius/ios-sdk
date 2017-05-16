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

    self = [super init];

    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];

    if (self) {
        [lrUser setObject:token forKey:@"lrAccessToken"];

        long lrUserBlocked = [[userProfile objectForKey:@"IsDeleted"] integerValue];

        //User is not blocked
        if(lrUserBlocked == 0) {
            [lrUser setInteger:true forKey:@"isLoggedIn"];
            [lrUser setInteger:false forKey:@"lrUserBlocked"];
        } else {
            [lrUser setInteger:true forKey:@"lrUserBlocked"];
        }

        NSMutableDictionary* profile;
        if (![userProfile objectForKey:@"errorCode"]) {
            profile = [[userProfile mutableCopy] replaceNullWithBlank];
            [lrUser setObject:profile forKey:@"lrUserProfile"];
        }

        self.accessToken = token;
        self.userProfile = [profile copy];
    }

    return self;
}

@end
