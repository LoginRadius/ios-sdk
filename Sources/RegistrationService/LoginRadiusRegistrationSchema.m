//
//  LoginRadiusRegistrationSchema.m
//  Pods
//
//  Created by Thompson Sanjoto on 2017-06-02.
//
//

#import <Foundation/Foundation.h>
#import "LoginRadiusRegistrationSchema.h"
#import "NSMutableDictionary+LRMutableDictionary.h"

@implementation LoginRadiusRegistrationSchema

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusRegistrationSchema *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusRegistrationSchema alloc] init];
	});

	return instance;
}

- (void) setWithArrayOfDictionary:(NSArray*) array;
{
    NSMutableArray *newFields = [[NSMutableArray alloc] init];
    
    for (NSDictionary* fieldDict in array)
    {
        NSMutableDictionary *fieldFormatted = [[fieldDict mutableCopy] replaceNullWithBlank];
        LoginRadiusField *newField = [[LoginRadiusField alloc] init:fieldFormatted];
        [newFields addObject:newField];
    }
    
    _fields = [newFields copy];
}

- (NSArray<LoginRadiusField *> *) getRequiredUserProfileFields
{
    NSMutableArray<LoginRadiusField *> *arr = [[NSMutableArray<LoginRadiusField *> alloc] init];
    for (LoginRadiusField *field in [self fields])
    {
        //if the field is required but not password/confirmpassword
        if(field.isRequired && !([[field name] isEqualToString:@"password"]||[[field name] isEqualToString:@"confirmpassword"]))
        {
            [arr addObject:field];
        }
    }
    return [arr copy];
}

- (NSArray<LoginRadiusField *> *) getRequiredVerifiedFields
{
    NSMutableArray<LoginRadiusField *> *arr = [[NSMutableArray<LoginRadiusField *> alloc] init];
    for (LoginRadiusField *field in [self fields])
    {
        if(([[field name] isEqualToString:@"emailid"]||[[field name] isEqualToString:@"phoneid"]))
        {
            [arr addObject:field];
        }
    }
    return [arr copy];
}

@end
