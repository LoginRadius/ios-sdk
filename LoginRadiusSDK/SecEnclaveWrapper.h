//
//  SecEnclaveWrapper.h
//  Pods
//
//  Created by Megha Agarwal on 01/12/22.
//

#import <Foundation/Foundation.h>


/**
 The SecEnclaveWrapper class is using SecureEnclave to generate keys and use them to encrypt/decrypt sensitive data.
 It is an abstraction layer for the iPhone Keychain communication and Secure Enclave.
 The SecureEnclave support is only available for iOS 10+.
 
 */

@interface SecEnclaveWrapper : NSObject
//Return encrypted form of data
- (NSData *_Nonnull)encryptData:(NSData *_Nonnull)data ;
//Return decryrpted value of encrypted data
- (NSData *_Nonnull)decryptData:(NSData *_Nonnull)data ;


//  @return an initialised instance.

- (instancetype _Nonnull )init;

/**
 Delete public key in the Keychain
 */
- (void) deletePubKey ;
/**
 Delete prrivate key in the SecureEnclave
 */
- (void) deletePrivateKey ;

@end

