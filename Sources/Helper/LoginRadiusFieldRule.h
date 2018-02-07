//
//  LoginRadiusField.h
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LoginRadiusFieldRuleType) {
    unknown,
    alpha_dash,
    exact_length,
    matches,
    max_length,
    min_length,
    numeric,
    required,
    valid_ca_zip,
    valid_email,
    valid_ip,
    valid_url,
    valid_date,
    custom_validation
};
#define LoginRadiusFieldRuleType(enum) [@[@"unknown",@"alpha dash",@"exact length",@"matches",@"max length",@"min length",@"numeric",@"required",@"valid canadian zip",@"valid email",@"valid ip",@"valid url",@"valid date",@"custom validation"] objectAtIndex:enum]

@interface LoginRadiusFieldRule : NSObject
    @property (nonatomic) LoginRadiusFieldRuleType type;
    @property (strong, nonatomic, nullable) NSString *regex;
    @property (nonatomic, nullable) NSNumber *intValue;
    @property (strong, nonatomic, nullable) NSString *stringValue;
    - (instancetype _Nonnull)init:(NSString* _Nonnull)ruleStr;
    - (NSString* _Nonnull)typeToString;
@end
