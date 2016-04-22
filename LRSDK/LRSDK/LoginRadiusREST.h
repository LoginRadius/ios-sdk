#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusREST : NSObject
+ (instancetype) sharedInstance;
- (void)callAPIEndpoint:(NSString*)endpoint
				 method:(NSString*)httpMethod
				 params:(NSDictionary*)params
	  completionHandler:(responseHandler)completion;

@end
