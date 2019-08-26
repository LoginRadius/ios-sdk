//
//  LRSession.m
//  LoginRadiusSDK
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import "LRSession.h"
#import "LRMutableDictionary.h"
#import "LoginRadiusSDK.h"
#import "SimpleKeychain.h"
#import "LoginRadius.h"

@interface LRSession()
@end

@implementation LRSession

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LRSession *instance;
	dispatch_once(&onceToken, ^{
		instance = [LRSession instance];
	});

	return instance;
}

+ (instancetype)instance {

    return [[LRSession alloc] init];
}

- (nullable NSString*) accessToken {
    
    NSString *token = nil;
    
    if([[LoginRadiusSDK sharedInstance] useKeychain])
    {
        //retrive keychain
        //KeychainAccessVersionNumber
        NSString *appIdentifierPrefix = [self bundleSeedID];
        
        NSString *groupKey = [NSString stringWithFormat:@"%@.%@",appIdentifierPrefix,[LoginRadiusSDK siteName]];

        A0SimpleKeychain *keychain = [A0SimpleKeychain keychainWithService:[LoginRadiusSDK siteName] accessGroup:groupKey];
        
        token = [keychain stringForKey:@"lrAccessToken"];
    }else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        token = [defaults valueForKey:@"lrAccessToken"];
        
    }
    
    return token;
}

- (nullable NSDictionary*) userProfile {
    
    NSDictionary *profile = nil;
    
    if([[LoginRadiusSDK sharedInstance] useKeychain])
    {
        //retrive keychain
        NSString *appIdentifierPrefix = [self bundleSeedID];
        
        NSString *groupKey = [NSString stringWithFormat:@"%@.%@",appIdentifierPrefix,[LoginRadiusSDK siteName]];

        A0SimpleKeychain *keychain = [A0SimpleKeychain keychainWithService:[LoginRadiusSDK siteName] accessGroup:groupKey];
        
        NSData *profileData = [keychain dataForKey:@"lrUserProfile"];
        NSDictionary *profileDict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:profileData];

        profile = profileDict;
    }else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        profile = [defaults valueForKey:@"lrUserProfile"];
        
    }
    
    return profile;
}

- (instancetype)initWithAccessToken:(NSString*_Nonnull)token userProfile:(NSDictionary*_Nonnull)userProfile{

    self = [super init];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long lrUserBlocked = [[userProfile objectForKey:@"IsDeleted"] integerValue];

    if([[LoginRadiusSDK sharedInstance] useKeychain])
    {
        //save to keychain
        NSString *appIdentifierPrefix = [self bundleSeedID];
        
        NSString *groupKey = [NSString stringWithFormat:@"%@.%@",appIdentifierPrefix,[LoginRadiusSDK siteName]];

        A0SimpleKeychain *keychain = [A0SimpleKeychain keychainWithService:[LoginRadiusSDK siteName] accessGroup:groupKey];
        
        [keychain setString:token forKey:@"lrAccessToken"];
        
        BOOL yes = YES;
        BOOL no = NO;
        
        if(lrUserBlocked == 0) {
            [keychain setData: [NSData dataWithBytes:&(yes) length:sizeof(BOOL)] forKey:@"isLoggedIn" ];
            [keychain setData:[NSData dataWithBytes:&no length:sizeof(BOOL)] forKey:@"lrUserBlocked"];
        } else
        {
            [keychain setData:[NSData dataWithBytes:&yes length:sizeof(BOOL)] forKey:@"lrUserBlocked"];
        }
        
        NSMutableDictionary* profile;
        if (![userProfile objectForKey:@"errorCode"]) {
            profile = [[userProfile mutableCopy] replaceNullWithBlank];
            NSData *profileData = [NSKeyedArchiver archivedDataWithRootObject:profile];
            [keychain setData:profileData forKey:@"lrUserProfile"];
        }
    }else
    {
        //save to user defaults
        [defaults setObject:token forKey:@"lrAccessToken"];
        //User is not blocked
        if(lrUserBlocked == 0) {
            [defaults setInteger:true forKey:@"isLoggedIn"];
            [defaults setInteger:false forKey:@"lrUserBlocked"];
        } else {
            [defaults setInteger:true forKey:@"lrUserBlocked"];
        }
        
        NSMutableDictionary* profile;
        if (![userProfile objectForKey:@"errorCode"]) {
            profile = [[userProfile mutableCopy] replaceNullWithBlank];
            [defaults setObject:profile forKey:@"lrUserProfile"];
        }

    }
    
    return self;
}

- (BOOL) logout
{
    //if its already logged out then don't do anything
    //and if user specify don't invalidate the access token

    if(![self isLoggedIn])
    {
        return NO;
    }

    [[AuthenticationAPI authInstance] invalidateAccessToken: [self accessToken] completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"Failed to invalidate LRtoken: %@",[error localizedDescription]);
        }else{
#ifdef DEBUG
            NSLog(@"Succesfully invalidate LRToken");
#endif
        }
    }];
    
    if([[LoginRadiusSDK sharedInstance] useKeychain])
    {
        NSString *appIdentifierPrefix = [self bundleSeedID];
        
        NSString *groupKey = [NSString stringWithFormat:@"%@.%@",appIdentifierPrefix,[LoginRadiusSDK siteName]];

        A0SimpleKeychain *keychain = [A0SimpleKeychain keychainWithService:[LoginRadiusSDK siteName] accessGroup:groupKey];
        
        [keychain deleteEntryForKey:@"isLoggedIn"];
        [keychain deleteEntryForKey:@"lrAccessToken"];
        [keychain deleteEntryForKey:@"lrUserBlocked"];
        [keychain deleteEntryForKey:@"lrUserProfile"];

    }else
    {
        NSUserDefaults *lrUserDefault = [NSUserDefaults standardUserDefaults];
        [lrUserDefault removeObjectForKey:@"isLoggedIn"];
        [lrUserDefault removeObjectForKey:@"lrAccessToken"];
        [lrUserDefault removeObjectForKey:@"lrUserBlocked"];
        [lrUserDefault removeObjectForKey:@"lrUserProfile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (BOOL) isLoggedIn
{
    return ([self accessToken] && [self userProfile]);
}

- (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge NSString *)kSecClassGenericPassword, (__bridge NSString *)kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}

@end
