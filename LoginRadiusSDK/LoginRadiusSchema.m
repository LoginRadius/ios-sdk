//
//  LoginRadiusRegistrationSchema.m
//  Pods
//
//  Created by Thompson Sanjoto on 2017-06-02.
//
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSchema.h"
#import "LRMutableDictionary.h"

@implementation LoginRadiusSchema

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusSchema *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusSchema alloc] init];
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

- (void) setSchema:(NSDictionary*) data;
{
   if (data[@"SocialSchema"]){
        NSArray *providersObj = [data[@"SocialSchema"] objectForKey:@"Providers"];
        NSMutableArray * providersItems = [NSMutableArray array];
        for(NSDictionary * providersDictionary in providersObj){
            LoginRadiusField * providersItem = [[LoginRadiusField alloc] initWithSocialSchema:providersDictionary];
            [providersItems addObject:providersItem];
        }
        _providers = providersItems;
    }
    
    if (data[@"RegistrationFormSchema"]){
        NSArray * array = data[@"RegistrationFormSchema"];
        NSMutableArray *newFields = [[NSMutableArray alloc] init];
        
        for (NSDictionary* fieldDict in array)
        {
            
            NSMutableDictionary* rules = [fieldDict mutableCopy];
            NSString *dtc = rules[@"rules"];
            if ([dtc containsString:@"custom_validation"]){
                rules[@"rules"] = @"";
            }
            NSMutableDictionary *fieldFormatted = [[rules mutableCopy] replaceNullWithBlank];
            LoginRadiusField *newField = [[LoginRadiusField alloc] init:fieldFormatted];
            [newFields addObject:newField];
        }
        
        _fields = [newFields copy];
        
    }
}



- (void)checkRequiredFieldsWithSchema: (NSDictionary *) schema
                              profile: (NSDictionary *)profile
                    completionHandler: (LRAPIResponseHandler) completion
{
    
    NSArray * registrationSchemaDictionaries = schema[@"RegistrationFormSchema"];
    NSDictionary *lowercasedProfile = [profile dictionaryWithLowercaseKeys];
    
    //check if we need to ask for fields
    NSMutableArray * items = [NSMutableArray new];
   
    for(NSDictionary * field in registrationSchemaDictionaries)
    {
       
        NSString *fName = [[field valueForKey:@"name"] lowercaseString];
        NSString *fRules = [[field valueForKey:@"rules"] lowercaseString];
        
        if ([fRules isEqual:@"required"] || [fRules hasPrefix:@"required|"] || [fRules isEqual:@"valid_email|required"]) {
            int miss = 0;
            
            if (([[lowercasedProfile objectForKey:fName] isEqual:(id)[NSNull null]] && ![fName isEqual:@"emailid"] && ![fName  hasPrefix:@"cf"])|| ([[lowercasedProfile objectForKey:fName] isEqual:@""] && ![fName isEqual:@"emailid"] && ![fName  hasPrefix:@"cf"])) {
              miss = 1;
              
            }
            
            if (([fName isEqual:@"phonenumber"] && [[lowercasedProfile objectForKey:@"phonenumbers"] isEqual:(id)[NSNull null]]) || ([fName isEqual:@"phonenumber"] && [[lowercasedProfile objectForKey:@"phonenumbers"]  isEqual: @""])){
                 miss = 1;
            }
            
            if (([fName isEqual:@"phonetype"] && [[lowercasedProfile objectForKey:@"phonenumbers"] isEqual:(id)[NSNull null]]) || ([fName isEqual:@"phonetype"] && [[lowercasedProfile objectForKey:@"phonenumbers"]  isEqual: @""])){
                miss = 1;
            }
            
            
            
            if (([fName isEqual:@"emailsubscription"] && [[lowercasedProfile objectForKey:@"subscription"]  isEqual:(id)[NSNull null]]) || ([fName isEqual:@"emailsubscription"] && [[lowercasedProfile objectForKey:@"subscription"]  isEqual: @""])){
                 miss = 1;
            }
            
            BOOL email = [[lowercasedProfile objectForKey:@"emailverified"] boolValue];
            
            if ([fName isEqual:@"emailid"] && email == NO) {
                 miss = 1;
            }
            
            BOOL phone = [[lowercasedProfile objectForKey:@"phoneidverified"] boolValue];
            if ([fName  isEqual: @"phoneid"] && phone == NO) {
                 miss = 1;
            }
            
            
            
            if([fName  hasPrefix:@"cf"] && [[lowercasedProfile objectForKey:@"customfields"] isEqual:(id)[NSNull null]]){
                  miss = 1;
                
            }else if([fName  hasPrefix:@"cf"] && [lowercasedProfile objectForKey:@"customfields"] != nil) {
                NSMutableString *customFields = [NSMutableString stringWithString:fName];
                [customFields deleteCharactersInRange:NSMakeRange(0, 3)];
                if([lowercasedProfile[@"customfields"] valueForKey:customFields] == nil || [[lowercasedProfile[@"customfields"] valueForKey:customFields] isEqual:@""]){
                      miss = 1;
                }else if([fName  hasPrefix:@"cf"] && [[lowercasedProfile objectForKey:@"customfields"]  isEqual: @{}]) {
                      miss = 1;
                }
            }
            
            if(miss > 0 && miss == 1){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[field valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[field valueForKey:@"Checked"] forKey:@"Checked"];
            [dict setObject:[field valueForKey:@"type"] forKey:@"type"];
            [dict setObject:[field valueForKey:@"display"] forKey:@"display"];
            [dict setObject:[field valueForKey:@"rules"] forKey:@"rules"];
            [dict setObject:[field valueForKey:@"options"] forKey:@"options"];
            [dict setObject:[field valueForKey:@"permission"] forKey:@"permission"];
            [dict setObject:[field valueForKey:@"DataSource"] forKey:@"DataSource"];
            [dict setObject:[field valueForKey:@"Parent"] forKey:@"Parent"];
            [dict setObject:[field valueForKey:@"ParentDataSource"] forKey:@"ParentDataSource"];
            [items addObject: dict];
            
            }
        }
        
    }
    
    //call UI to fill the fields
    if([items count] > 0)
    {
        [self setWithArrayOfDictionary:items];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:items forKey:@"MissingRequiredFields"];
        completion([dict copy], [LRErrors userProfileRequireAdditionalFields]);
        return;
    }
    
    
    
    
    //User is verified and no fields are missing
    NSMutableDictionary *noMissing = [[NSMutableDictionary alloc] init];
    NSMutableArray * Noitems = [NSMutableArray new];
    [noMissing setObject:Noitems forKey:@"NoFields"];
    completion(noMissing, nil);
    
    //should get mandatory fields
    
    
}

@end
