//
//  UserAuth.m
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import "UserAuth.h"

@implementation UserAuth

+ (instancetype)shareInstance {
    static UserAuth *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [UserAuth new];
    });
    return instance;
}

@end
