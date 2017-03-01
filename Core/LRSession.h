//
//  LRSession.h
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface LRSession : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDictionary *userProfile;

- (instancetype)initWithAccessToken:(NSString *)token userProfile:(NSDictionary*)userProfile;

@end
