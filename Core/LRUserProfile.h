//
//  LRUserProfile.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRUserProfile : NSObject

@property (readonly, nonatomic) NSString *uid;
@property (readonly, nullable, nonatomic) NSArray *emails;
@property (readonly, nonatomic) NSArray *linkedProfiles;

@property (readonly, nonatomic) NSString *isLoggedIn;
@property (readonly, nonatomic) NSString *isBlocked;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
