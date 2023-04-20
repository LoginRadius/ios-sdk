5.8.0 Release notes (2023-04-20)
=============================================================

### Enhancements
* Added FaceID helper in the LoginRadius SDK for authentication through facial recognition. 
  For detailed information on FaceID, please refer to the following document:
    https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id


5.7.0 Release notes (2022-12-27)
=============================================================

### Enhancements
* Added Secure Enclave in the LoginRadius SDK to encrypt/decrypt sensitive data. For detailed information on Secure Enclave, please refer to the following document : https://support.apple.com/en-in/guide/security/sec59b0b31ff/web 


5.6.2 Release notes (2022-08-29)
=============================================================

### Enhancements
* Upgraded FBSDK dependencies in LoginRadiusSDK for new build system of new Xcode.

### Breaking changes

* As part of FBSDK version 13+ it is required to set FacebookClientToken in the project's Info.plist file. For details on FacebookClientToken please see Facebook document : https://developers.facebook.com/docs/ios/getting-started/#client-token

5.6.1 Release notes (2022-03-03)
=============================================================

### Removed (Deprecated) API:

* getUserprofileWithAccessToken (Social User Profile EndPoint)

In this iOS SDK version, we have removed/deprecated the `getUserprofileWithAccessToken` method (Social User Profile EndPoint ). This API endpoint will also be deprecated from the LoginRadius backend soon, so we will suggest please use `profilesWithAccessToken` method instead of `getUserprofileWithAccessToken` method.

To know more about the Implementation of this API please refer to this [document](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#social-user-profile).


5.6.0 Release notes (2021-11-08)
=============================================================

### Enhancements
* Added support to pass custom headers in the SDK. 
* Added support to set the Referer header in the SDK.

5.5.0 Release notes (2021-03-30)
=============================================================

### Enhancements
* Upgraded FBSDK dependencies in LoginRadiusSDK for new build system of new Xcode.
* Upgraded Eureka version to latest in Swift demo on Xcode.
* Dropping support for Xcode versions below 11. This is in line with Apple's plans to disallow submission of Apps that do not include the iOS 13 SDK.

5.4.2 Release notes (2020-08-27)
=============================================================

### Enhancements
* Changed nil unwrapping process for SourceApplication as Apple returns nil for SourceApplication in iOS 13
* Added a new optional parameter to native social login methods for supporting multiple social apps for same provider 
* Upgraded Eureka version to 5.2.1 for crashing in Swift demo on Xcode v11.4 or above

5.4.1 Release notes (2020-05-08)
=============================================================

### Enhancements
* Replaced UIWebView with WKWebView in SDK

5.4.0 Release notes (2020-02-06)
=============================================================

### Enhancements
* Added new Apple SignIn Native Login. 
* Added new Wechat Native Login.

5.3.0 Release notes (2019-08-26)
=============================================================

### Enhancements
* Added new PIN Authentication APIs. PIN authentication is an alternate way to do authentication, instead of password users can use the PIN. PIN Authentication can be used for re-authentication also (when the user accesses a specific section or area).
* Updated the logout method type as BOOL.

5.2.0 Release notes (2019-06-20)
=============================================================

### Enhancements
* Updated FBSDKLoginKit and FBSDKCoreKit - 4.27.0 to 5.0.2

### Bugfixes
* Fixed FBSDKLoginKit Version - 5.0.2 : Error - Semantic issue
* Fixed Build issue in LoginRadius Swift Demo with Swift Version 5.0
* Fixed Build issue With TwitterKit Version -3.4.2

5.1.2 Release notes (2018-12-18)
=============================================================

### Bugfixes
* Fixed issue iOS 10 and below App crashes when tapped on Cancel button in sfsafariviewcontroller(WebView).
* Fixed Build issue in LoginRadius Swift Demo with Swift Version 4.2


5.1.1 Release notes (2018-11-16)
=============================================================

### API breaking changes

* Updated LoginRadius Google Native EndPoint Also, 
* Updated the convertGoogleToken() methods of the above API .


### Bugfixes
* Fixed google refresh token issue in native login.


5.1.0 Release notes (2018-10-31)
=============================================================

### API breaking changes

* Updated endpoints and renamed ""Auto Login"" to ""Smart Login"", ""No Registration/Simplified Registration"" to ""One touch Login"" and ""Instant Link Login"" to ""PasswordLess Login"". Also, changed the methods of the above APIs accordingly."

### Enhancements

* Improved native social login performance for better native user experience.
* Added new custom domain option.
* Updated FBSDKLoginKit - 4.27.0 to FBSDKLoginKit - 4.36.0.
* SOTT is added as a header in Registration API.
* Added new Privacy Policy API.
* Added new Reset Password By Email OTP API.
* Added new Verify Email By OTP API.
* Access Token is added as a header in all Authentication APIs.
* Added preventEmailVerification (Boolean) option to prevent email verification flow in Auth Login and Registration APIs (where optional email is enabled).
* Added new Send Welcome Email API.
* Significantly improved code performance.

### Bugfixes
* Fixed FBSDKLoginKit - 4.36.0 : Error - Semantic issue - Redefinition of 'EMAIL' in LoginRadiusField.h
* Fixed SDK required field issue.
* Fixed demo issue in Objective-C and Swift.



5.0.0 Release notes (2018-02-07)
=============================================================

### API breaking changes

* All the classes are restructed and 'Registration Service' class is depericated, inplace of this now we have multiple sections of Api such as:
 AuthenticationAPI,SocialAPI,CustomObjectAPI,AutoLoginAPI,ConfigurationAPI,InstantLoginAPI,SimplifiedRegistrationAPI.

### Enhancements

* Tiny size overhead to your application, below 380kb for everything.
* Improved native login performance for better native user experience.
* Add new Some Missing APIs AuthenticationAPI section.
* Add new All SocialAPI section.
* Add new All AutoLoginAPI section.
* Add new ConfigurationAPI section.
* Add new InstantLoginAPI section.
* Add new SimplifiedRegistrationAPI section.
* Significantly improved code performance.

### Bugfixes
* Fix social login issue in old devices and browsers.
* Fix delete APIs issue related to body parameters.


4.1.2 Release notes (2017-11-02)
=============================================================

### SwiftDemo Enhancements
* Add Login by Username
* Automatically call Username Availability when Username is in dynamic registration
* Add asserts on SOTT if not initialized

### Bugfixes
* Fix Username Availability Call

4.1.1 Release notes (2017-11-02)
=============================================================

### Bugfixes
* Fix Facebook Native calling finishlogin twice on 0 permission

4.1.0 Release notes (2017-09-27)
=============================================================
### Enhancements
* Support XCode 9 compiler
* Update from Swift 3.2 to Swift 4, in the Swift Demo

### Bugfixes
* Fix Twitter Native Authentication flow in iOS 11

4.0.0
=============================================================

### API breaking changes

* Registration through hosted pages is removed, it is done through API.
* Registration Service uses LoginRadius APIv2.
* URL Scheme is now ``<sitename>.<app bundle id>`` to support mobile ios sso

### Enhancements
* Add LoginRadiusRegistrationSchema, LoginRadiusField, LoginRadiusFieldRule class
* Add getSocialProvidersList API call to get dynamic list of configured social providers in LR dashboard
* Add getRegistrationSchema API call to get dynamic list of configured registration field in LR dashboard
* Add the option to store credentials in Apple's Keychain 
* Have mobile iOS SSO as of result of using Apple's Keychain
* Add dynamic registration fields in Swift Demo
* Add missing fields handling in Swift Demo
* API calls for custom objects and validate/invalidate access tokens
* More error codes and handling

### Bugfixes
* More error handling in twitter native.

3.4.0 Release notes (2017-06-05)
=============================================================

### API breaking changes
* Merged LoginRadiusRegistrationManager and LoginRadiusSocialLoginManager into LoginRadiusManager
* Remove Support for iOS 8.0, minimum deployment is 9.0
* Use NSNotification to handle actions instead of callbacks (user can navigate to register/login/forgot in hosted page)

### Enhancements

* Use SafariViewController on traditional login
* Improved Swift Demo
* Improved ObjC Demo
* Update Mobile Hosted Page to v4
* Add Custom Mobile Hosted Page functionality
* Add Mobile Hosted Page intercation with Native Login
* Add more error messages and handling

### Bugfixes

* Normal social login for google is now fixed
* When user nagivates to register/login in hosted page, it will call the right callback

3.3 Release notes (2017-03-08)
=============================================================

### API breaking changes

* SDK is renamed to LoginRadiusSDK
* SDK needs to be initialized by creating a LoginRadius.plist and adding the appropriate key/values.
* All the classes are restructed, hence the method calls for Registration Service, Social Login,
  Native Social Login are changed.

### Enhancements

* Cocoapods upgrade
* Using AFNetworking for networking tasks.
* Changed the way application delegate methods are propagated
* Registration and Social Login are accessible from their respective classes instead of LoginRadiusSDK
* Basic TouchID Support
* Using SFSafariViewController for webview social login.
* Better Error messages from LoginRadius API

### Bugfixes

* Twitter Native Login issue when no accounts are configured.
* Fix LoginRadiusREST bugs

3.2.2 Release notes (2017-02-28)
=============================================================

### API breaking changes

### Enhancements

### Bugfixes

* Fixed Facbook login with webview issue while loading facebook auth page.

3.2.1 Release notes (2016-10-25)
=============================================================

### API breaking changes

### Enhancements

### Bugfixes

* Fixed JSON parsing issue while Yahoo login

3.2.0 Release notes (2016-10-25)
=============================================================

### API breaking changes

### Enhancements

* Upgraded the Facebook SDK pod dependency to support iOS 10.

### Bugfixes

* Fixed category issue with NSMutableDictionary.

3.1.1 Release notes (2016-08-16)
=============================================================

### API breaking changes

### Enhancements

* Added example for calling Social API

### Bugfixes

* Fixed a redirection bug in Social login through Registration Hosted pages.

3.1 Release notes (2016-07-28)
=============================================================

### API breaking changes

### Enhancements

* Support for Cocoapods installation

### Bugfixes

* SDK is no longer distributed as a universal framework, since it is
  causing issues while the app the uploaded to itunesconnect


3.0.1 Release notes (2016-06-29)
=============================================================

### API breaking changes

### Enhancements

### Bugfixes

* Fixed webview's getting stuck if there is any network issue

3.0 Release notes (2016-05-19)
=============================================================

### API breaking changes

* This is a complete revamp of the previous SDK. All the classes are re-written for providing ease of implementation.
* Social Login and User Registration Service are previously implementing by sub-classing the relevant ViewController classes. This will no longer work. Now all these functionality is handled by SDK itself, all you have to do is pass your UIViewController where these actions are supposed to take place.
* Removed all the delegates for login and registration, instead use completionHandler blocks.

### Enhancements

* Social Login & User Registration can be implemented by a simple call to LoginRadiusSDK class.
* All the functionality is abstracted in LoginRadiusSDK class.
* Support for Facebook native login

### Bugfixes

* Fixed Twitter native login
