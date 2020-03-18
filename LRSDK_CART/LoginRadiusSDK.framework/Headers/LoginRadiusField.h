//
//  LoginRadiusField.h
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusFieldRule.h"

typedef NS_ENUM(NSUInteger, LoginRadiusFieldType) {
    STRING, //this is single row text
    OPTION, //this is for html select, need to check field's option for full possible option values
    MULTI, //this is 'checkbox' in dashboard for checkbox
    PASSWORD,
    HIDDEN,
    EMAILID,
    TEXT, //this is text area, meaning multi-line text area
    DATE //this field type only exist in iOS, core field type is a string.
};
#define LoginRadiusFieldType(enum) [@[@"string",@"option",@"multi",@"password",@"hidden",@"email",@"text",@"date"] objectAtIndex:enum]


typedef NS_ENUM(NSUInteger, LoginRadiusFieldPermission) {
    READ,
    WRITE
};

@interface LoginRadiusField : NSObject
    @property (nonatomic) LoginRadiusFieldType type;
    @property (strong, nonatomic) NSString * _Nonnull name; // unique field name
    @property (strong, nonatomic) NSString * _Nonnull display; // display name
    @property (strong, nonatomic, nullable) NSDictionary<NSString *, NSString *> *option;
    @property (nonatomic) LoginRadiusFieldPermission permission;
    @property (strong, nonatomic, nullable) NSArray<LoginRadiusFieldRule *> *rules;
    @property (nonatomic, getter=getIsRequired) BOOL isRequired; //will loop through rules for a 'required' rule
    @property (nonatomic, strong) NSString *_Nullable endpoint;
    @property (nonatomic, strong) NSString *_Nullable providerName;

    -(instancetype)initWithSocialSchema:(NSDictionary *)dictionary;
    - (instancetype _Nonnull )init:(NSDictionary*_Nonnull)dictionary;
    - (NSString* _Nonnull)typeToString;
    + (NSArray<NSString *> *_Nonnull) addressFields;
@end
