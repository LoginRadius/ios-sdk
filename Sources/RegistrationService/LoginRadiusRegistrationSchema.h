//
//  LoginRadiusRegistrationSchema.h
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusField.h"

@interface LoginRadiusRegistrationSchema : NSObject
    @property (strong, nonatomic,nullable) NSArray<LoginRadiusField *> *fields;
    @property (nonatomic, getter=getRequiredUserProfileFields,nullable) NSArray<LoginRadiusField *> *requiredUserProfileFields;
    @property (nonatomic, getter=getRequiredVerifiedFields,nullable) NSArray<LoginRadiusField *> *requiredVerifiedFields;
    + (instancetype _Nonnull) sharedInstance;
    - (void) setWithArrayOfDictionary:(NSArray*_Nonnull) array;
@end
