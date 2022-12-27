//
//  LoginRadiusEncrcyptor.m
//  Pods
//
//  Created by Megha Agarwal on 01/12/22.
//

//
//  LoginRadiusEncryptor.m

#import "LoginRadiusEncryptor.h"
#import "LoginRadiusSDK.h"

@implementation LoginRadiusEncryptor 

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoginRadiusEncryptor *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[LoginRadiusEncryptor alloc] init];
    });
    
    return instance;
}

- (NSData *)EncryptDecryptText:(NSData *)data {
    
    //Encrypt the string.
    NSString *apikey = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
   
   
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *strGroupID = [NSString stringWithFormat:@"group.%@",bundleIdentifier];
    
    SecEnclaveWrapper *keychainItem = [[SecEnclaveWrapper alloc] init];
    
    NSData *encrypted = [keychainItem encryptData:[apikey dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *strEncrypted = [[NSString alloc] initWithData:encrypted encoding:NSASCIIStringEncoding];
   
    
    
    //Decrypt the string.
    NSData *decrypted =[keychainItem decryptData:encrypted];
    NSString *strDecrypted = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
    
    NSData *stringData = [strDecrypted dataUsingEncoding:NSUTF8StringEncoding];
    return stringData;
    
}

@end

