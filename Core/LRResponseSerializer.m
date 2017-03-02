//
//  LRResponseSerializer.m
//  Pods
//
//  Created by Raviteja Ghanta on 03/03/17.
//
//

#import "LRResponseSerializer.h"
#import "NSError+LRError.h"

@implementation LRResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError **)error {
    id responseObject = nil;
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        NSError *validateError = *error;
        if (validateError) {
            NSError *jsonError;
            NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            NSError *loginRadiusError;

            if (!jsonError) { // HTTP Not acceptable errorCode. Deserialize LoginRadius Error if payload present

                if([payload[@"IsProviderError"] boolValue]) {
                    loginRadiusError = [NSError errorWithCode:[payload[@"ErrorCode"] integerValue] description:payload[@"Provider Error"] failureReason:payload[@"ProviderErrorResponse"]];
                } else {
                    loginRadiusError = [NSError errorWithCode:[payload[@"ErrorCode"] integerValue] description:payload[@"Description"] failureReason:payload[@"Message"]];
                }

                (*error) = loginRadiusError;
            } else {
                (*error) = validateError;
            }
        }
    } else {
        responseObject = [super responseObjectForResponse:response data:data error:error];
    }
    return responseObject;
}

@end
