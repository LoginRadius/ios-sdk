//
//  LoginRadiusEncryptor.h
//  Pods
//
//  Created by Megha Agarwal on 01/12/22.
//


#import <Foundation/Foundation.h>
#import "SecEnclaveWrapper.h"

@interface LoginRadiusEncryptor : NSObject 

#pragma mark - LoginRadiusEncryptor Initilizers

+ (instancetype)sharedInstance;
/**
 *  Initializer
 *  @return singleton instance
 */
-(NSData *_Nonnull)EncryptDecryptText:(NSData *_Nonnull)data ;

@end
