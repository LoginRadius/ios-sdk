//
//  LRClient.h
//  Pods
//
//  Created by Raviteja Ghanta on 20/02/17.
//
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"

@interface LRClient : NSObject

/**
 *  shared singleton
 *
 *  @return singleton instance of REST client
 */
+ (instancetype) sharedInstance;

- (void)getUserProfileWithAccessToken:(NSString *)token isNative:(BOOL)isNative completionHandler:(LRAPIResponseHandler) completion;

@end
