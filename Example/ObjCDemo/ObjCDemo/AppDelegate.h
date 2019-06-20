//
//  AppDelegate.h
//  ObjCDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/* Google Native Sign in
#import <Google/SignIn.h>
*/
/* Twitter Native Sign in
#import <TwitterKit/TWTRKit.h>
*/
@interface AppDelegate : UIResponder <UIApplicationDelegate>
/* Google Native Sign in, GIDSignInDelegate>
*/

@property (strong, nonatomic) UIWindow *window;
+(BOOL) useGoogleNative;
+(BOOL) useTwitterNative;
+(BOOL) useFacebookNative;

@end

