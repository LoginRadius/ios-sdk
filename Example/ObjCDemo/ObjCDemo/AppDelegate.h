//
//  AppDelegate.h
//  ObjCDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
/* Google Native SignIn
#import <Google/SignIn.h>
*/
@interface AppDelegate : UIResponder <UIApplicationDelegate>
/* Google Native SignIn, GIDSignInDelegate>
*/

@property (strong, nonatomic) UIWindow *window;
+(BOOL) useGoogleNative;
+(BOOL) useTwitterNative;
+(BOOL) useFacebookNative;

@end

