//
//  LoginRadiusUtilities.m
//  LoginRadius
//
//  Created by Lucius Yu on 2015-06-03.
//  Copyright (c) 2016 LoginRadius. All rights reserved.
//
#import "LoginRadiusUtilities.h"

@implementation LoginRadiusUtilities

- (NSData *)parseDatatoJsonData :(NSMutableDictionary *)data {
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    
    return postdata;
}


- (NSMutableDictionary *)sendSyncGetRequest :(NSString *)urlString {
    
    NSLog(@"Sync GET API url => %@", urlString);
    //    NSURL *url = [NSURL URLWithString:urlString];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if(data.length > 0 && error == nil) {
        
        // Get Json, Parse Json, Remove Null Keys
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        return json;
        
    } else {
        NSLog(@" API Error - Sync GET api call");
        NSLog(@"%@", error);
        NSMutableDictionary *error = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Sync Get API call", @"Error",
                                      nil];
        return error;
    }
}

- (NSMutableURLRequest *)createPostAPIRequest :(NSString *)endpoint :(NSString *)method :(NSString *)dataLength :(NSData *)dataBody {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:endpoint]];
    [request setHTTPMethod:method];
    [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataBody];
    
    return request;
}

- (BOOL)lrSaveUserData :(NSMutableDictionary *)userProfile lrToken:(NSString *)token {
    
    BOOL isSaved = FALSE;
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    

    
    if (!token || [@""  isEqual: token]) {
        NSLog(@"SETTING ISLOGGEDIN TO FALSE");i
        [lrUser setInteger:false forKey:@"isLoggedIn"];
        isSaved = FALSE;
    }else {
        
        if (!userProfile) {
            userProfile = [self lrGetUserProfile:token];
        }

        long lrUserBlocked = [[userProfile objectForKey:@"IsDeleted"] integerValue];
        NSLog(@"User social profile => %@", userProfile);
        
        if(lrUserBlocked == 0) {
            NSLog(@"User is NOT blocked");
            [lrUser setInteger:false forKey:@"lrUserBlocked"];
        } else {
            NSLog(@"User is blocked");
            NSLog(@"Delete value => %li", lrUserBlocked);
            [lrUser setInteger:true forKey:@"lrUserBlocked"];
        }
        
        if (![userProfile objectForKey:@"errorCode"]) {
            [lrUser setObject:userProfile forKey:@"lrUserProfile"];
        }
    
        isSaved = TRUE;
    }
    
    
    return isSaved;
}

- (BOOL)lrSaveUserRaaSData :(NSString *)token APIKey:(NSString *)key {
    BOOL isSaved = false;
    id userLinkedProfile = [self lrGetUserLinkedProfile:token APIKey:key];
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    
    int error = false;
    for (id object in userLinkedProfile) {
        if ([object objectForKey:@"errorCode"]) {
            error = true;
        }
    }
    
    if(!error) {
        [lrUser setObject:userLinkedProfile forKey:@"lrUserLinkedProfile"];
        isSaved = true;
    }
    return isSaved;
}

- (NSMutableDictionary *)lrGetUserProfile :(NSString *)token {
    static NSString * const profile_url = @"https://api.loginradius.com/api/v2/userprofile?access_token=%@";
    NSMutableDictionary *userProfile = [self sendSyncGetRequest:[[NSString alloc] initWithFormat:profile_url, token]];
    userProfile = [userProfile replaceNullWithBlank];
    //    NSLog(@"User Profile is => %@", userProfile);
    
    return userProfile;
}

- (NSMutableArray *)lrGetUserLinkedProfile :(NSString *)token APIKey:(NSString *)key{
    static NSString * const profile_url = @"https://api.loginradius.com/raas/client/auth/linkedprofiles?appkey=%@&access_token=%@";
    NSMutableDictionary *userProfile = [self sendSyncGetRequest:[[NSString alloc] initWithFormat:profile_url, key, token]];
    
    //    NSLog(@"user profile list => %@", userProfile);
    id userProfileArray = [[NSMutableArray alloc] init];
    NSLog(@"class name is %@", [userProfileArray class]);
    
    
    if([userProfileArray isKindOfClass:[NSArray class]]) {
        for (id object in userProfile) {
            [userProfileArray addObject:[(NSMutableDictionary *)object replaceNullWithBlank]];
        }
        return userProfileArray;
    } else {
        return nil;
    }
    
}

- (NSString *)GetUidFromProfile :(NSMutableDictionary *)profile {
    NSString *uid = [profile objectForKey:@"Uid"];
    if (uid) {
        return uid;
    } else {
        return nil;
    }
}

- (NSString *)GetEmailFromProfile :(NSMutableDictionary *)profile {
    NSString *email = [profile objectForKey:@"Email"];
    if(email) {
        return email;
    } else {
        return nil;
    }
}

- (NSString *)URLEncodedString :(NSString *)urlString {
    __autoreleasing NSString *encodedString;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)urlString,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}

- (NSString *)URLDecodedString :(NSString *)urlString {
    __autoreleasing NSString *decodedString;
    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                          NULL,
                                                                                                          (__bridge CFStringRef)urlString,
                                                                                                          CFSTR(""),
                                                                                                          kCFStringEncodingUTF8
                                                                                                          );
    return decodedString;
}

- (NSDictionary *)dictionaryWithQueryString: (NSString *)queryString {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count == 2)
        {
            NSString *key = elements[0];
            NSString *value = elements[1];
            NSString *decodedKey = [self URLDecodedString :key];
            NSString *decodedValue = [self URLDecodedString :value];
            
            if (![key isEqualToString:decodedKey])
                key = decodedKey;
            
            if (![value isEqualToString:decodedValue])
                value = decodedValue;
            
            [dictionary setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}


@end

@implementation NSMutableDictionary (LoginRadius)

- (NSMutableDictionary *) replaceNullWithBlank {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        //        NSLog(@"Key processed => %@", key);
        
        const id object = [self objectForKey: key];
        //        if ([key isEqual: @"InterestedIn"]) {
        //            NSLog(@"Type of %@ is => %@", key, [object class]);
        //        }
        
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        } else if ([object isKindOfClass: [NSDictionary class]]) {
            NSInteger count = [object count];
            if ( count != 0 ) {
                [replaced setObject: [(NSMutableDictionary *) object replaceNullWithBlank] forKey: key];
            }
        } else if ( [object isKindOfClass: [NSArray class]] ) {
            //NSLog(@" [Empty] key => %@", key);
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self objectForKey:key]];
            for (int i=0; i < [tempArray count]; i++) {
                id arrayItem = [tempArray objectAtIndex:i];
                if([arrayItem isKindOfClass:[NSDictionary class]]) {
                    [tempArray setObject:[arrayItem replaceNullWithBlank] atIndexedSubscript:i];
                }
            }
            [replaced setObject:tempArray forKey:key];
        }
    }
    return [replaced mutableCopy];
}

@end