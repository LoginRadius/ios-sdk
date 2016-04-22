//
//  LRSDK.h
//  LRSDK
//
//  Created by Raviteja Ghanta on 22/04/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for LRSDK.
FOUNDATION_EXPORT double LRSDKVersionNumber;

//! Project version string for LRSDK.
FOUNDATION_EXPORT const unsigned char LRSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like


#if __has_include(<Social/Social.h>) && __has_include(<Accounts/Accounts.h>)
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#endif

#import <LRSDK/LoginRadiusSDK.h>


