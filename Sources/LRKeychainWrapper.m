//
//  LRKeychainWrapper.h
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import "LRKeychainWrapper.h"
#import <UIKit/UIKit.h>
#define newCFDict CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks)

@interface LRKeychainWrapper ()

@end

@implementation LRKeychainWrapper
static NSData    *publicKeyBits;
static SecKeyRef publicKeyRef;
static SecKeyRef privateKeyRef;

- (instancetype)init {
    NSString *service = [[NSBundle mainBundle] bundleIdentifier];
    return [self initWithIdentifier:service accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service {
    return [self initWithIdentifier:service accessGroup:nil];
}

- (instancetype)initWithIdentifier:(NSString *)service accessGroup:(NSString *)accessGroup {
    self = [super init];
    if (self) {
        _service = service;
        _accessGroup = accessGroup;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue]
        >= 10.0) {
        if(![self lookupPublicKeyRef] || ![self lookupPrivateKeyRef])
            [self generatePasscodeKeyPair];
    }
    
    return self;
}

- (NSData *)dataForKey:(NSString *)key {
    return [self dataForKey:key promptMessage:nil];
}

- (NSData *)dataForKey:(NSString *)key promptMessage:(NSString *)message {
    NSData *d = [self dataForKey:key promptMessage:message error:nil];
    return d;
}

- (NSData *)dataForKey:(NSString *)key promptMessage:(NSString *)message error:(NSError**)err {
    if (!key) {
        return nil;
    }
    
    NSDictionary *query = [self queryFetchOneByKey:key message:message];
    CFTypeRef data = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
    if (status != errSecSuccess) {
        
        return nil;
    }
    
    NSData *dataFound = [NSData dataWithData:(__bridge NSData *)data];
    if (data) {
        CFRelease(data);
    }
    NSData * returnData = dataFound;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]
        >= 10.0)
        returnData = [self decryptData:dataFound];
    return returnData;
}

- (BOOL)hasValueForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    NSDictionary *query = [self queryFindByKey:key message:nil];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    return status == errSecSuccess;
}
- (BOOL)setData:(NSData *)data forKey:(NSString *)key {
    return [self setData:data forKey:key promptMessage:nil];
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key promptMessage:(NSString *)message {
    if (!key) {
        return NO;
    }
    NSData * returnData = data;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]
        >= 10.0)
        returnData = [self encryptData:data];
    NSDictionary *query = [self queryFindByKey:key message:message];
    
    // Normal case
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    if (status == errSecSuccess) {
        if (returnData) {
            NSDictionary *updateQuery = [self queryUpdateValue:returnData message:message];
            
            status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)updateQuery);
            return status == errSecSuccess;
        } else {
            OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
            return status == errSecSuccess;
        }
    } else {
        NSDictionary *newQuery = [self queryNewKey:key value:returnData];
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)newQuery, NULL);
        return status == errSecSuccess;
    }
}

- (BOOL)deleteEntryForKey:(NSString *)key {
    if (!key) {
        return NO;
    }
    NSDictionary *deleteQuery = [self queryFindByKey:key message:nil];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
    return status == errSecSuccess;
}

- (void)clearAll {
#if !TARGET_IPHONE_SIMULATOR
    NSDictionary *query = [self queryFindAll];
    CFArrayRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        NSArray *items = [NSArray arrayWithArray:(__bridge NSArray *)result];
        CFBridgingRelease(result);
        for (NSDictionary *item in items) {
            NSMutableDictionary *queryDelete = [[NSMutableDictionary alloc] initWithDictionary:item];
            queryDelete[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
            
            OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDelete);
            if (status != errSecSuccess) {
                break;
            }
        }
    }
#else
    NSMutableDictionary *queryDelete = [self baseQuery];
    queryDelete[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    //   queryDelete[(__bridge id)kSecUseOperationPrompt] = @"";
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDelete);
    if (status != errSecSuccess) {
        return;
    }
#endif
}

#pragma mark - Query Dictionary Builder methods

- (NSMutableDictionary *)baseQuery {
    NSMutableDictionary *attributes = [@{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: self.service,
    } mutableCopy];
#if !TARGET_IPHONE_SIMULATOR
    if (self.accessGroup) {
        attributes[(__bridge id)kSecAttrAccessGroup] = self.accessGroup;
    }
#endif
    
    return attributes;
}

- (NSDictionary *)queryFindAll {
    NSMutableDictionary *query = [self baseQuery];
    [query addEntriesFromDictionary:@{
        (__bridge id)kSecReturnAttributes: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitAll,
    }];
    return query;
}

- (NSDictionary *)queryFindByKey:(NSString *)key message:(NSString *)message {
    NSAssert(key != nil, @"Must have a valid non-nil key");
    NSMutableDictionary *query = [self baseQuery];
    query[(__bridge id)kSecAttrAccount] = key;
#if !TARGET_IPHONE_SIMULATOR
    if (message) {
        query[(__bridge id)kSecUseOperationPrompt] = message;
    }
#endif
    return query;
}

- (NSDictionary *)queryUpdateValue:(NSData *)data message:(NSString *)message {
    if (message) {
        return @{
#if !TARGET_IPHONE_SIMULATOR
            (__bridge id)kSecUseOperationPrompt: message,
#endif
            (__bridge id)kSecValueData: data,
        };
    } else {
        return @{
            (__bridge id)kSecValueData: data,
        };
    }
}

- (NSDictionary *)queryNewKey:(NSString *)key value:(NSData *)value {
    NSMutableDictionary *query = [self baseQuery];
    query[(__bridge id)kSecAttrAccount] = key;
    query[(__bridge id)kSecValueData] = value;
    query[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly;
    
    return query;
}

- (NSDictionary *)queryFetchOneByKey:(NSString *)key message:(NSString *)message {
    NSMutableDictionary *query = [self baseQuery];
    [query addEntriesFromDictionary:@{
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
        (__bridge id)kSecAttrAccount: key,
    }];
    
    return query;
}
- (NSData *)encryptData:(NSData *)data {
    if (data && data.length) {
        
        CFDataRef cipher = SecKeyCreateEncryptedData(publicKeyRef, kSecKeyAlgorithmECIESEncryptionStandardX963SHA256AESGCM, (CFDataRef)data, nil);
        
        // returnData = (__bridge NSData *)cipher;
        return (__bridge NSData *)cipher;
    } else {
        return nil;
        
    }
}
- (NSData*)decryptData:(NSData *)data {
    
    if(data && data.length){
        
        CFDataRef plainData = SecKeyCreateDecryptedData(privateKeyRef, kSecKeyAlgorithmECIESEncryptionStandardX963SHA256AESGCM, (CFDataRef)data, nil);
        return  (__bridge NSData *)plainData;
    }
    else {
        return nil;
    }
}
#pragma mark - Key related methods
- (bool)publicKeyExists
{
    CFTypeRef publicKeyResult = nil;
    CFMutableDictionaryRef publicKeyExistsQuery = newCFDict;
    CFDictionarySetValue(publicKeyExistsQuery, kSecClass,               kSecClassKey);
    CFDictionarySetValue(publicKeyExistsQuery, kSecAttrKeyType,         kSecAttrKeyTypeEC);
    CFDictionarySetValue(publicKeyExistsQuery, kSecAttrApplicationTag,  kPublicKeyName);
    CFDictionarySetValue(publicKeyExistsQuery, kSecAttrKeyClass,        kSecAttrKeyClassPublic);
    CFDictionarySetValue(publicKeyExistsQuery, kSecReturnData,          kCFBooleanTrue);
    
    OSStatus status = SecItemCopyMatching(publicKeyExistsQuery, (CFTypeRef *)&publicKeyResult);
    
    if (status == errSecItemNotFound) {
        return false;
    }
    else if (status == errSecSuccess) {
        return true;
    }
    else {
        [NSException raise:@"Unexpected OSStatus" format:@"Status: %i", status];
        return nil;
    }
}
- (SecKeyRef) lookupPublicKeyRef
{
    OSStatus sanityCheck = noErr;
    NSData *tag;
    id keyClass;
    
    if (publicKeyRef != NULL) {
        // already exists in memory, return
        return publicKeyRef;
    }
    tag = [kPublicKeyName dataUsingEncoding:NSUTF8StringEncoding];
    keyClass = (__bridge id) kSecAttrKeyClassPublic;
    
    
    NSDictionary *queryDict = @{
       
        (__bridge id) kSecClass : (__bridge id) kSecClassKey,
        (__bridge id) kSecAttrKeyType : (__bridge id) kSecAttrKeyTypeEC,
        (__bridge id) kSecAttrApplicationTag : tag,
        (__bridge id) kSecAttrKeyClass : keyClass,
        (__bridge id) kSecReturnRef : (__bridge id) kCFBooleanTrue
    };
    
    sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef) queryDict, (CFTypeRef *) &publicKeyRef);
    if (sanityCheck != errSecSuccess) {
        NSLog(@"Error trying to retrieve key from server.  sanityCheck: %d", (int)sanityCheck);
    }
    
    
    return publicKeyRef;
}

- (NSData *) publicKeyBits
{
    if (![self publicKeyExists])
        return nil;
    return (NSData *) CFDictionaryGetValue((CFDictionaryRef)[self lookupPublicKeyRef], kSecValueData);
    
}

- (SecKeyRef) lookupPrivateKeyRef
{
    CFMutableDictionaryRef getPrivateKeyRef = newCFDict;
    CFDictionarySetValue(getPrivateKeyRef, kSecClass, kSecClassKey);
    CFDictionarySetValue(getPrivateKeyRef, kSecAttrKeyClass, kSecAttrKeyClassPrivate);
    CFDictionarySetValue(getPrivateKeyRef, kSecAttrLabel, kPrivateKeyName);
    CFDictionarySetValue(getPrivateKeyRef, kSecReturnRef, kCFBooleanTrue);
    //   CFDictionarySetValue(getPrivateKeyRef, kSecUseOperationPrompt, @"Authenticate to sign data");
    
    OSStatus status = SecItemCopyMatching(getPrivateKeyRef, (CFTypeRef *)&privateKeyRef);
    if (status == errSecItemNotFound)
        return nil;
    
    return (SecKeyRef)privateKeyRef;
}

- (bool) generatePasscodeKeyPair
{
    CFErrorRef error = NULL;
    SecAccessControlRef sacObject = SecAccessControlCreateWithFlags(
                                                                    kCFAllocatorDefault,
                                                                    kSecAttrAccessibleAlwaysThisDeviceOnly,
                                                                    kSecAccessControlPrivateKeyUsage,
                                                                    &error
                                                                    );
    
    if (error != errSecSuccess) {
        NSLog(@"Generate key error: %@\n", error);
    }
    
    return [self generateKeyPairWithAccessControlObject:sacObject];
}

- (bool) generateKeyPairWithAccessControlObject:(SecAccessControlRef)accessControlRef
{
    // create dict of private key info
    CFMutableDictionaryRef accessControlDict = newCFDict;;
#if !TARGET_IPHONE_SIMULATOR
    
    CFDictionaryAddValue(accessControlDict, kSecAttrAccessControl, accessControlRef);
#endif
    CFDictionaryAddValue(accessControlDict, kSecAttrIsPermanent, kCFBooleanTrue);
    CFDictionaryAddValue(accessControlDict, kSecAttrLabel, kPrivateKeyName);
    
    // create dict which actually saves key into keychain
    CFMutableDictionaryRef generatePairRef = newCFDict;
#if !TARGET_IPHONE_SIMULATOR
    
    CFDictionaryAddValue(generatePairRef, kSecAttrTokenID, kSecAttrTokenIDSecureEnclave);
#endif
    CFDictionaryAddValue(generatePairRef, kSecAttrKeyType, kSecAttrKeyTypeEC);
    CFDictionaryAddValue(generatePairRef, kSecAttrKeySizeInBits, (__bridge const void *)([NSNumber numberWithInt:256]));
    CFDictionaryAddValue(generatePairRef, kSecPrivateKeyAttrs, accessControlDict);
    
    OSStatus status = SecKeyGeneratePair(generatePairRef, &publicKeyRef, &privateKeyRef);
    
    if (status != errSecSuccess){
        NSLog(@"Error trying to retrieve key from server.  sanityCheck: %d", (int)status);

        return NO;
    }
    [self savePublicKeyFromRef:publicKeyRef];
    return YES;
}

- (bool) savePublicKeyFromRef:(SecKeyRef)publicKeyRef
{   OSStatus sanityCheck = noErr;
    NSData *tag;
    id keyClass;
    
    
    tag = [kPublicKeyName dataUsingEncoding:NSUTF8StringEncoding];
    keyClass = (__bridge id) kSecAttrKeyClassPublic;
    
    
    NSDictionary *saveDict = @{
       
        (__bridge id) kSecClass : (__bridge id) kSecClassKey,
        (__bridge id) kSecAttrKeyType : (__bridge id) kSecAttrKeyTypeEC,
        (__bridge id) kSecAttrApplicationTag : tag,
        (__bridge id) kSecAttrKeyClass : keyClass,
        (__bridge id) kSecValueData : (__bridge NSData *)SecKeyCopyExternalRepresentation(publicKeyRef,nil),
        (__bridge id) kSecAttrKeySizeInBits : [NSNumber numberWithUnsignedInteger:256],
        (__bridge id) kSecAttrEffectiveKeySize : [NSNumber numberWithUnsignedInteger:256],
        (__bridge id) kSecAttrCanDerive : (__bridge id) kCFBooleanFalse,
        (__bridge id) kSecAttrCanEncrypt : (__bridge id) kCFBooleanTrue,
        (__bridge id) kSecAttrCanDecrypt : (__bridge id) kCFBooleanFalse,
        (__bridge id) kSecAttrCanVerify : (__bridge id) kCFBooleanTrue,
        (__bridge id) kSecAttrCanSign : (__bridge id) kCFBooleanFalse,
        (__bridge id) kSecAttrCanWrap : (__bridge id) kCFBooleanTrue,
        (__bridge id) kSecAttrCanUnwrap : (__bridge id) kCFBooleanFalse
    };
    sanityCheck = SecItemAdd((__bridge CFDictionaryRef) saveDict, (CFTypeRef *)&publicKeyRef);
    if (sanityCheck != errSecSuccess) {
        NSLog(@"Error trying to retrieve key from server.  sanityCheck: %d", (int)sanityCheck);

    }
    
    return publicKeyRef;}

- (void) deletePubKey {
    NSDictionary *deleteKeyQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassKey,
        (__bridge id)kSecAttrApplicationTag: [kPublicKeyName dataUsingEncoding:NSUTF8StringEncoding],
        (__bridge id)kSecAttrType: (__bridge id)kSecAttrKeyTypeEC,
    };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteKeyQuery);
   if( status != errSecSuccess)
       NSLog(@"key couldn't be deleted");
}

- (void) deletePrivateKey {
    NSDictionary *deleteKeyQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassKey,
        (__bridge id)kSecAttrApplicationTag: [kPrivateKeyName dataUsingEncoding:NSUTF8StringEncoding],
        (__bridge id)kSecAttrType: (__bridge id)kSecAttrKeyTypeEC,
    };
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)deleteKeyQuery);
      if( status != errSecSuccess)
          NSLog(@"key couldn't be deleted");
}

@end
