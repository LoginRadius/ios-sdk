//
//  LoginRadiusField.m
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusFieldRule.h"

@implementation LoginRadiusFieldRule

- (instancetype)init:(NSString*)ruleStr
{
    self = [super init];
    if (self) {
        _type = [self setTypeWithString:ruleStr];
    }
    return self;
}

- (LoginRadiusFieldRuleType) setTypeWithString:(NSString*)ruleStr
{
    LoginRadiusFieldRuleType fieldType = unknown;
    
    if ([ruleStr hasPrefix:@"alpha_dash"]) {
        fieldType = alpha_dash;
        _regex = @"^[a-zA-Z0-9_-]+$";
    } else if ([ruleStr hasPrefix:@"exact_length"]) {
        fieldType = exact_length;
        _intValue = [[NSNumber alloc] initWithInt:[[self extractSquareBracketInformation:ruleStr] intValue]];
    } else if ([ruleStr hasPrefix:@"matches"]) {
        fieldType = matches;
        _stringValue = [self extractSquareBracketInformation:ruleStr];
    } else if ([ruleStr hasPrefix:@"max_length"]) {
        fieldType = max_length;
        _intValue = [[NSNumber alloc] initWithInt:[[self extractSquareBracketInformation:ruleStr] intValue]];
    } else if ([ruleStr hasPrefix:@"min_length"]) {
        fieldType = min_length;
        _intValue = [[NSNumber alloc] initWithInt:[[self extractSquareBracketInformation:ruleStr] intValue]];
    } else if ([ruleStr hasPrefix:@"numeric"]) {
        fieldType = numeric;
        _regex = @"^[0-9]+$";
    } else if ([ruleStr hasPrefix:@"required"]) {
        fieldType = required;
    } else if ([ruleStr hasPrefix:@"valid_ca_zip"]) {
        fieldType = valid_ca_zip;
        _regex = @"^[ABCEGHJKLMNPRSTVXY]{1}\\d{1}[A-Z]{1} *\\d{1}[A-Z]{1}\\d{1}$";
    } else if ([ruleStr hasPrefix:@"valid_email"]) {
        fieldType = valid_email;
        _regex = @"\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    } else if ([ruleStr hasPrefix:@"valid_ip"]) {
        fieldType = valid_ip;
        _regex = @"^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$";
    } else if ([ruleStr hasPrefix:@"valid_url"]) {
        fieldType = valid_url;
        _regex = @"^((http|https):\\/\\/(\\w+:{0,1}w*@)?(\\S+)|)(:[0-9]+)?(\\/|\\/([\\w#!:.?+=&%@!\\-\\/]))?$";
    } else if ([ruleStr hasPrefix:@"callback_valid_date"]) {
        fieldType = valid_date;
    } else if ([ruleStr hasPrefix:@"custom_validation"]) {
        fieldType = custom_validation;
        NSString *customRule = [self extractSquareBracketInformation:ruleStr];
        NSRange divider = [customRule rangeOfString:@"###"];
        NSUInteger midPoint = divider.location+divider.length;
        @try
        {
            _regex = [customRule substringWithRange:NSMakeRange(0, divider.location)];
            _stringValue = [customRule substringWithRange:NSMakeRange(midPoint, [customRule length]-midPoint)];
        }@catch(NSException *exception)
        {
            //User inputs their own regex schema, should notify wihtout debug
            NSLog(@"Invalid Custom Regex, %@", exception.reason);
        }

    }
    
    return fieldType;
}

-(NSString*) extractSquareBracketInformation: (NSString*)ruleStr
{
        NSRange range = [ruleStr rangeOfString:@"["];
        range.location++;
        NSRange rangeBack = [ruleStr rangeOfString:@"]" options:NSBackwardsSearch];
        range.length = rangeBack.location - range.location;
        return [ruleStr substringWithRange:range];
}

-(NSString *)description
{
    NSString *lrfieldstr = [NSString stringWithFormat:@"<LoginRadiusFieldRule, type: %@, intValue: %@, stringValue: %@, regexValue:%@",[self typeToString], [self intValue], [self stringValue], [self regex]];
    
    lrfieldstr = [lrfieldstr stringByAppendingString:@">"];

    return lrfieldstr;
}

-(NSString*) typeToString
{
    return LoginRadiusFieldRuleType([self type]);
}

@end
