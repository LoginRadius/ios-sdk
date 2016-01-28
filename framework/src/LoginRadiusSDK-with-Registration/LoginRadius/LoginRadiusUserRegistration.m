//
//  LoginRadiusUserRegistration.m
//  LoginRadius
//
//  Created by Lucius Yu on 2015-06-03.
//  Copyright (c) 2016 LoginRadius. All rights reserved.
//

#import "LoginRadiusUserRegistration.h"

NSString *const REGISTER_URL = @"https://api.loginradius.com/raas/v1/user/register?appkey=%@&appsecret=%@";
NSString *const LOGIN_URL = @"https://api.loginradius.com/raas/v1/user?appkey=%@&appsecret=%@&username=%@&password=%@";
NSString *const FORGOTPASSWORD_URL = @"https://api.loginradius.com/raas/client/password/forgot?apikey=%@&emailId=%@&resetpasswordurl=%@";
NSString *const FB_NATIVE_AUTH_URL = @"https://api.loginradius.com/api/v2/access_token/facebook?key=%@&fb_access_token=%@";

@implementation LoginRadiusUserRegistration

- (void)lrRegister: (NSString *)key :(NSString *)secret :(NSMutableDictionary *)registerData {

    LoginRadiusUtilities *utility = [[LoginRadiusUtilities alloc] init];
    
    // Format Url with custom appkey and sceret
    NSString *apiEndPoint = [[NSString alloc] initWithFormat:REGISTER_URL, key, secret];
   // NSLog(@"API Url = > %@", apiEndPoint);
   // NSLog(@"User Data => %@",registerData);
    
    // Parse to JSON & get data length
    NSData *postData = [utility parseDatatoJsonData:registerData];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Format the API request
    NSMutableURLRequest *request = [utility createPostAPIRequest :apiEndPoint :@"POST" :postLength :postData];
    
    
    // Build the connection and handle the response in delegate
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Register connection succeed");
    } else {
        NSLog(@"Register connection failed");
    }
    
}

- (void)lrLogin :(NSString *)key :(NSString *)secret :(NSString *)username :(NSString *)password {
    
    NSString *apiEndPoint = [NSString stringWithFormat:LOGIN_URL, key, secret, username, password];
   // NSLog(@"Login Url => %@", apiEndPoint);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:apiEndPoint]];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Login Connection Successful");
    } else {
        NSLog(@"Login Connection Failed");
    }
    
}

- (void)lrForgotPassword :(NSString *)key :(NSString *)email :(NSString *)forgotpasswordUrl {
    NSString *apiEndPoint = [NSString stringWithFormat:FORGOTPASSWORD_URL, key, email, forgotpasswordUrl];
    NSLog(@"Forgotpassword Url => %@", apiEndPoint);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:apiEndPoint]];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Forgot Password Connection Successful");
    } else {
        NSLog(@"Forgot Password Connection Failed");
    }
    
}


- (BOOL)lrFbNativeLogin :(NSString *)key :(NSString *)token {
    
    NSString *apiEndPoint = [NSString stringWithFormat:FB_NATIVE_AUTH_URL, key, token];
    NSLog(@"Login Url => %@", apiEndPoint);
    
    LoginRadiusUtilities *util = [[LoginRadiusUtilities alloc]init];
    NSMutableDictionary *response = [util sendSyncGetRequest:apiEndPoint];
    
    if( [response objectForKey:@"access_token"] ) {
        NSString *lrAccessToken = [response objectForKey:@"access_token"];
        [util lrSaveUserData:nil lrToken:lrAccessToken];
        return true;
    } else {
        return false;
    }
    
}

- (void)lrLogout {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults *lrUserDefault = [NSUserDefaults standardUserDefaults];
    [lrUserDefault removeObjectForKey:@"isLoggedIn"];
    [lrUserDefault removeObjectForKey:@"lrAccessToken"];
    [lrUserDefault removeObjectForKey:@"lrUserBlocked"];
    [lrUserDefault removeObjectForKey:@"lrUserProfile"];
}



/*Response from server*/

- (void)connection: (NSURLConnection *)connection didReceiveData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSMutableDictionary* response = [[NSMutableDictionary alloc] initWithDictionary:json];
    
    response = [response replaceNullWithBlank];
    NSLog(@"Response from server => %@", response);
    
    NSInteger errorcode = (long)[response objectForKey:@"errorCode"];
    
    if(!errorcode){
        // Check if user logged in
        if([response objectForKey:@"Email"]) {
            
            LoginRadiusUtilities *util = [[LoginRadiusUtilities alloc] init];
            [util lrSaveUserData:response lrToken:@""];
            
            
        }
        [self.delegate handleResponse :TRUE :response];
        
    }else {
        [self.delegate handleResponse :FALSE :response];
    }
    
}

- (void)connection: (NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"API connection error => %@", error);
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
    // NSLog(@"connection did finish loading");
}

- (void)handleResponse:(BOOL)status :(NSDictionary *)response{
    
}
@end
