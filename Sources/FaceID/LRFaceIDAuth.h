//
//  LRFaceIDAuth.h
//  Pods
//
//  Created by Megha Agarwal on 15/12/22.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"



@interface LRFaceIDAuth : NSObject

#pragma mark - Init

/**
 *  Initializer
 *  @return singleton instance
 */
+ (instancetype)sharedInstance;



- (void)localAuthenticationWithFallbackTitle:(NSString *)localizedFallbackTitle
                                  completion:(LRServiceCompletionHandler)handler;

@end


