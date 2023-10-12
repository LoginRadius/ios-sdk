//
//  LRKeychainWrapper.h
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//
#import <Foundation/Foundation.h>
#define kPrivateKeyName @"com.loginradius.private"
#define kPublicKeyName @"com.loginradius.public"

/**
 The LRKeychainWrapper class is using SecureEnclave to generate keys and use them to encrypt/decrypt sensitive data.
 It is an abstraction layer for the iPhone Keychain communication and Secure Enclave.
 It has support for sharing keychain items using Access Group and also for iOS 8 fine grained accesibility over a specific Kyechain Item (Using Access Control).
 The SecurrerEnclave support is only available for iOS 10+, otherwise it will default use Keychain.
 
 */

@interface LRKeychainWrapper : NSObject

/**
 *  Service name under all items are saved. Default value is Bundle Identifier.
 */
@property (readonly, nonatomic) NSString *service;

/**
 *  Access Group for Keychain item sharing. If it's nil no keychain sharing is possible. Default value is nil.
 */
@property (readonly, nullable, nonatomic) NSString *accessGroup;


/**
 *  Initialise a `LRKeychainWrapper` with a given service and access group.
 *
 *  @param service name of the service to use to save items.
 *  @param accessGroup name of the access group to share items.
 *
 *  @return an initialised instance.
 */
- (instancetype)initWithIdentifier:(NSString *)service accessGroup:(nullable NSString *)accessGroup;

/**
 *  Saves the NSData with the type `kSecClassGenericPassword` in the keychain.
 *
 *  @param data value to save in the keychain
 *  @param key    key for the keychain entry.
 *
 *  @return if the value was saved it will return YES. Otherwise it'll return NO.
 */
- (BOOL)setData:(NSData *)data forKey:(NSString *)key;

/**
 *  Saves the NSData with the type `kSecClassGenericPassword` in the keychain.
 *
 *  @param data   value to save in the keychain
 *  @param key      key for the keychain entry.
 *  @param message  prompt message to display for TouchID/passcode prompt if neccesary
 *
 *  @return if the value was saved it will return YES. Otherwise it'll return NO.
 */
- (BOOL)setData:(NSData *)data forKey:(NSString *)key promptMessage:(nullable NSString *)message;

///---------------------------------------------------
/// @name Remove values
///---------------------------------------------------

/**
 *  Removes an entry from the Keychain using its key
 *  @param key the key of the entry to delete.
 *  @return If the entry was removed it will return YES. Otherwise it will return NO.
 */
- (BOOL)deleteEntryForKey:(NSString *)key;

/**
 *  Remove all entries from the kechain with the service and access group values.
 */
- (void)clearAll;


/**
 *  Fetches a NSData from the keychain
 *  @param key the key of the value to fetch
 *  @return the value or nil if an error occurs.
 */
- (nullable NSData *)dataForKey:(NSString *)key;

/**
 *  Fetches a NSData from the keychain
 *
 *  @param key     the key of the value to fetch
 *  @param message prompt message to display for TouchID/passcode prompt if neccesary
 *  @return the value or nil if an error occurs.
 */
- (nullable NSData *)dataForKey:(NSString *)key promptMessage:(nullable NSString *)message;

/**
 *  Fetches a NSData from the keychain
 *
 *  @param key     the key of the value to fetch
 *  @param message prompt message to display for TouchID/passcode prompt if neccesary
 *  @param err     Returns an error, if the item cannot be retrieved. F.e. item not found
 *                 or user authentication failed in TouchId case.
 *
 *  @return the value or nil if an error occurs.
 */
- (nullable NSData *)dataForKey:(NSString *)key promptMessage:(nullable NSString *)message error:(NSError **)err;

/**
 *  Checks if a key has a value in the Keychain
 *
 *  @param key the key to check if it has a value
 *
 *  @return if the key has an associated value in the Keychain or not.
 */
- (BOOL)hasValueForKey:(NSString *)key;
/**
 Delete public key in the Keychain
 */
- (void) deletePubKey ;
/**
 Delete prrivate key in the SecureEnclave
 */
- (void) deletePrivateKey ;
/**
 * Delete stored entry in Keychain
 * @param key the key to delete the entry for
 * @return key the key to erturn whether deleted successfully
 
 */
- (BOOL)deleteEntryForKey:(NSString *)key;
@end
