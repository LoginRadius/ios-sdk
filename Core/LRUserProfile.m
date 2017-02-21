//
//  LRUserProfile.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LRUserProfile.h"

@implementation LRUserProfile

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    long lrUserBlocked = [[dictionary objectForKey:@"IsDeleted"] integerValue];

    //User is not blocked
    if(lrUserBlocked == 0) {
        [lrUser setInteger:true forKey:@"isLoggedIn"];
        [lrUser setInteger:false forKey:@"lrUserBlocked"];
    } else {
        [lrUser setInteger:true forKey:@"lrUserBlocked"];
    }

    // TODO Correct other fields
}

@end
