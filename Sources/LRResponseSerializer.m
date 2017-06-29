//
//  LRResponseSerializer.m
//  Pods
//
//  Created by LoginRadius Development Team on 03/03/17.
//
//

#import "LRResponseSerializer.h"
#import "NSError+LRError.h"
#import "NSString+LRString.h"
#import "NSDictionary+LRDictionary.h"

static NSString * const errorCode = @"errorcode";
static NSString * const isProviderError = @"isprovidererror";
static NSString * const description = @"description";
static NSString * const providerErrorResponse = @"providererrorresponse";
static NSString * const message = @"message";

@implementation LRResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError **)error {
    id responseObject = nil;
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        NSError *validateError = *error;
        if (validateError) {
            NSError *jsonError;
            NSDictionary *payload = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError] dictionaryWithLowercaseKeys]; //lowercase all json dictionary keys
            
            NSError *loginRadiusError;

            if (!jsonError) { // HTTP Not acceptable errorCode. Deserialize LoginRadius Error if payload present

                if([payload[isProviderError] boolValue]) {
                    loginRadiusError = [NSError errorWithCode:[payload[errorCode] integerValue] description:payload[description] failureReason:payload[providerErrorResponse]];
                } else {
                    loginRadiusError = [NSError errorWithCode:[payload[errorCode] integerValue] description:payload[description] failureReason:payload[message]];
                }

                (*error) = loginRadiusError;
            } else {
                (*error) = validateError;
            }
        }
    } else {
    
        //if its a jsonp, unwrap it and send it to super
        if ([response.MIMEType  isEqual: @"application/javascript"])
        {
            responseObject = [super responseObjectForResponse:response data:[self convertJSONPtoJSON:data] error:error];
        }else
        {
            responseObject = [super responseObjectForResponse:response data:data error:error];
        }
        
    }
    return responseObject;
}

-(NSData*) convertJSONPtoJSON: (NSData*)jsonpData
{
        NSString *jsonString = [[NSString alloc] initWithData:jsonpData encoding:NSUTF8StringEncoding];
        NSRange range = [jsonString rangeOfString:@"("];
        range.location++;
        NSRange rangeBack = [jsonString rangeOfString:@")" options:NSBackwardsSearch];
        range.length = rangeBack.location - range.location;
        jsonString = [jsonString substringWithRange:range];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        return jsonData;
}

@end
