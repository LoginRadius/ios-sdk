//
//  LoginRadiusRegistrationSchema.h
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusField.h"
#import "LoginRadius.h"

@interface LoginRadiusSchema : NSObject
@property (strong, nonatomic,nullable) NSArray<LoginRadiusField *> *fields;
@property (strong, nonatomic,nullable) NSArray<LoginRadiusField *> *providers;

+ (instancetype _Nonnull) sharedInstance;
- (void) setSchema:(NSDictionary*_Nonnull) data;
- (void) setWithArrayOfDictionary:(NSArray*_Nonnull) array;

- (void)checkRequiredFieldsWithSchema: (NSDictionary *_Nonnull) schema
                              profile: (NSDictionary * _Nonnull)profile
                    completionHandler: (LRAPIResponseHandler _Nonnull ) completion;
@end
