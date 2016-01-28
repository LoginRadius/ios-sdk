//
//  LoginRadiusService.m
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-08.
//  Copyright (c) 2016 LoginRadius. All rights reserved.
//

#import "LoginRadiusService.h"
#import "LoginRadiusUtilities.h"

@implementation LoginRadiusService 

@synthesize updatedUserProfile;

- (void)loginradiusUserProfile: (NSString *) token {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.loginradius.com/api/v2/userprofile?access_token=%@", token]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    if(data.length > 0 && error == nil) {
        
        // Parse JSON into Dictionary
        NSDictionary *userProfile = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSMutableDictionary *dict = [userProfile mutableCopy];
        dict = [dict replaceNullWithBlank];
        
        
        // Save NSDictionary Profile into NSUserDefualt
        NSUserDefaults *loginradiusUserData = [NSUserDefaults standardUserDefaults];
        [loginradiusUserData setObject:dict forKey:@"userProfile"];
        return;
    } else {
        NSLog(@" API Error - User Profile ");
        return;
    }
    
}

- (void) loginradiusContact:(NSString *)token :(NSString *)nextcursor {
    /**
     * API format:
     * https://api.loginradius.com/api/v2/contact?access_token=:access_token&nextcursor=:nextcursor
     **/
    
    NSString *endpoint = [NSString stringWithFormat:@"https://api.loginradius.com/api/v2/contact?access_token=%@&nextcursor=%@", token, nextcursor];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", endpoint]]];
    [request setHTTPMethod:@"GET"];
     NSLog(@"NS URL => %@", [request URL]);
    
}

- (void) loginradiusPostStatus:(NSString *)title description:(NSString *)description {
    /**
     * API format:
     * /api/v2/status?access_token={access_token}&title={title}&url={url}&imageurl={imageurl}&
     * status={status}&caption={caption}&description={description}
     **/
    
    // Parse title & description into URL friendly form
LoginRadiusUtilities *util = [[LoginRadiusUtilities alloc] init];
    
    // TODO - add this part to Utility function -> Get token
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"lrAccessToken"];
    title = [util URLEncodedString:title];
    description = [util URLEncodedString:description];
    NSString *post = [NSString stringWithFormat:@"status/js?access_token=%@&title=%@&url=&imageurl=&caption=&description=@&status=%@", token, title, description];
    NSLog(@"post message AFTER encoding=> %@", post);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.loginradius.com/api/v2/%@", post]]];
    [request setHTTPMethod:@"GET"];
    NSLog(@"NS URL => %@", [request URL]);
    
    // Create URLConnection object
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection Failed");
    }
    
}


- (void)connection: (NSURLConnection *)connection didReceiveData:(NSData *)responseData {
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSLog(@"%@", dict);
    
    // Check status for isPosted
    bool isPosted = [dict objectForKey:@"isPosted"];
    if( isPosted ) {
        NSLog(@" Is posted ");
        [self.delegate LoginRadiusPostStatusSuccess:YES];
    } else {
        NSLog(@" Not posted");
        [self.delegate LoginRadiusPostStatusSuccess:NO];
    }
}

- (void)connection: (NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error");
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
    NSLog(@"connection did finish loading");
}

@end