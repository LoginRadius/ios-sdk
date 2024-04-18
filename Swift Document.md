# iOS Library Swift

This document provides instructions to integrate the LoginRadius User Registration Service or Social Login in an iOS app using Swift Language.

**Disclaimer**

This library is meant to help you with a quick implementation of the LoginRadius platform and also to serve as a reference point for the LoginRadius API. Keep in mind that it is an open-source library, which means you are free to download and customize the library functions based on your specific application needs.

## Requirements

[OS X](http://www.apple.com/macos/sierra/), [Xcode](https://developer.apple.com/xcode/) and iOS 11 or higher.

This SDK represents a new SDK written entirely in Swift.

 
## Installation

**Swift Package Manager**
 
[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler. 


To add LoginRadiusSDK to your project using SwiftPM follow these steps:

1. Open your project in Xcode

2. In the main menu, select File -> Swift Packages -> Add Package Dependency...

3. In the window, enter the package url [https://github.com/LoginRadius/ios-sdk.git](https://github.com/LoginRadius/ios-sdk.git)  and branch is **SwiftSDK-Master**


To use LoginRadiusSDK in your code, import the module file as needed:

Swift

```
import LoginRadiusPackage
```

## Setup Prerequisites

To get your app supported by LoginRadius iOS Swift SDK, you need to slightly configure your LoginRadius user account.

1. Enable <AppName>:// in your Admin Console -> Deployment > Apps > Web Apps. Ex: sampleapp://

2. Configure Email Templates \
By default your email template should look like this:

![image](https://github.com/lrengineering/swift-sdk-ios-customer-identity-/assets/118890027/ef504fda-e821-4377-8693-bfc4b99bfe74)

Change the following URL

Url#?vtype=emailverification&vtoken=#GUID#
to

Url#?vtype=emailverification&vtoken=#GUID#&apikey=<Your-LoginRadius-API-Key>
And the same changes should also be applied to your "Reset Password Email Template Configuration."

### Initialize SDK

1. Create a new File `LoginRadius.plist` and add it to your App

2. Add the following entries to your `LoginRadius.plist`

| Key | Type | Required |
|---|---|---|
| apiKey | String | Yes |
| siteName | String | Yes |
| verificationUrl | String | Optional,(Default URL: https://auth.lrcontent.com/mobile/verification/index.html) |
| useKeychain* | Boolean | Optional, No by default |
| customDomain | String | Optional,(Default URL: https://api.loginradius.com/) |
| customHeaders | Dictionary | Optional,(add string type key value pairs, e.g “x-headerkeyExample": “<< header value>>" ) |
| registrationSource | String | Optional,(Default: iOS) |

*useKeychain needs to enable keychain sharing to work properly, to see visually how to enable it see [here](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#singlesignon11)

Obtaining Sitename and API key

Details on obtaining Sitename [here](https://www.loginradius.com/docs/api/v2/admin-console/deployment/get-site-app-name/#locate-your-loginradius-site-name-on-the-admin-console) and API key [here](https://www.loginradius.com/docs/api/v2/admin-console/platform-security/api-key-and-secret/#api-key-and-secret)

1. Import the module in your source code.

Swift

```
import LoginRadiusSwiftSDK
```

**Application is launched**

Initialize the SDK with your API key and Site name in your `AppDelegate.swift`

Swift

```
import LoginRadiusSwiftSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let sdk:LoginRadiusSDK = LoginRadiusSDK.sharedInstance
    sdk.applicationLaunchedWithOptions(launchOptions)

            //Your code

            return true
 }
```

**Application to listen your URL**

You need to configure your Custom URL Scheme for this library to work.

1. In Xcode, right-click on your project's .plist file and select Open As -> Source Code. *Default plist is usually your Info.plist file*

2. Insert the following XML snippet into the body of your file just before the final element. Replace `{your-sitename}` with your LoginRadius Site Name. And then Replace `{your-app-bundle-identifier}` with your app's bundle identifier. If you don't know where is your app bundle identifier, see 2a.
```

<key>CFBundleURLTypes</key>
<array>
<dict>
 <key>CFBundleURLSchemes</key>
 <array>
   <string>{your-sitename}.{your-app-bundle-identifier}</string>
 </array>
</dict>
</array>

```

4. If you don't know where is your app bundle identifier, see below


![image](https://github.com/lrengineering/swift-sdk-ios-customer-identity-/assets/118890027/3eab6c87-2d78-40bd-92a7-376f6116f596)

**Application is asked to open URL**

Call this to handle URL's for social login to work properly in your `AppDelegate.swift `and `SceneDelegate.swift`

In AppDelegate.swift

```
import LoginRadiusSwiftSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        var canOpen = false
canOpen = (canOpen || LoginRadiusSDK.sharedInstance.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))
       
        return canOpen
 }
```

In SceneDelegate.swift

```
import LoginRadiusSwiftSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
    
        LoginRadiusSDK.sharedInstance.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: (Any).self)
    }

}

```

### Integrate Registration Service

Registration service supports traditional registration and login methods.

Registration Service is done through the Authentication API.

Registration requires a parameter called SOTT. You can create the SOTT token by following this [doc](https://www.loginradius.com/docs/api/v2/customer-identity-api/sott-usage/#staticsott4)

**Parameters and their Description:**

| Name | Description | Required |
|---|---|---|
| SOTT | Secure One-time Token which you can check information about sott here | Yes for Registration.You can generate a long term SOTT token from the Admin Console under Deployment -> Apps -> Mobile Apps (SOTT).|
| smstemplate | SMS template allows you to customize the formatting and text of SMS sent by users who share your content. | NO |
| emailTemplate | Email templates allow you to customize the formatting and text of emails sent by users who share your content. Templates can be text-only, or HTML and text, in which case the user's email client will determine which is displayed. | NO Go To API Configuration -> Email Workflow to get the template names |


**Registration by Email:**

```
let email:AnyObject = [ "Type":"Primary","Value":"test@gmail.com" ] as AnyObject
        let parameter:AnyObject = [ "Email": [email],
                                    "Password":"password"
                                  ]as AnyObject
  AuthenticationAPI.shared.userRegistration(withSott: sott, payload: parameter as! [String : Any], emailtemplate: nil, smstemplate: nil, preventVerificationEmail: false, completionHandler: { (data, error) in
                    
            if let err = error
                    {
                        print(err.localizedDescription)
                    }else{
                        print("successfully registered");
                    }
            })
```

Registration API will only create a user. To retrieve userprofile and access_token, please call Login API.

For all the possible payload fields, please check the Auth User Registration by Email [API](https://www.loginradius.com/docs/api/v2/user-registration/auth-user-registration-by-email)

**Registration by Phone:**

```
let parameter:AnyObject = [ "PhoneId": "xxxxxxx",
                                    "Password":"password"
                                  ]as AnyObject
        AuthenticationAPI.shared.userRegistration(withSott:sott,payload:parameter as! [String : Any], emailtemplate:"", smstemplate:"",preventVerificationEmail:false, completionHandler: { (data, error) in
                if let err = error
                {
                    print(err.localizedDescription)
                }else{
                    print("successfully registered");
                }
        })
```

### Integrate Traditional Login

Following code can be used for the implementation of traditional login:

**Login by Email:**

Call this function to login the user by email.

```
let parameter:AnyObject = ["email":email,
                                   "password":password,
                                   "securityanswer":""
                                  ]as AnyObject
  AuthenticationAPI.shared.login(withPayload:parameter as! [String : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
             if let err = error {
                print(err.localizedDescription)
            } else {
                print("login successful")
                
            }
```

**Login by Phone:**

Call this function to login the user by phone.

```
let parameter:AnyObject = ["phone":"",
                                  "password":"",
                                  "securityanswer":""
                                ]as AnyObject
        AuthenticationAPI.shared.login(withPayload:parameter as! [String : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
             if let err = error {
                print(err.localizedDescription)
            } else {
                print("login successful")
            }
        })
```

**Login by UserName:**

Call this function to login the user by username.

```
let parameter:AnyObject = ["username":"","password":"",
                                   "securityanswer":""
                                  ]as AnyObject
        AuthenticationAPI.shared.login(withPayload:parameter as! [String : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
             if let err = error {
                print(err.localizedDescription)
            } else {
                print("login successful")
            }
        })
```

You can store access_token and userProfile after successful login in LRSession for a long time.

```
LRSession.init(token: token as String, userProfile: profile! as! [String:Any])
```

After storing the value, you can get the userProfile and access_token from LRSession.

<!-- Check for `isLoggedIn` on app launch to check if the user is logged in`  -->

```
let profile = LoginRadiusSDK.sharedInstance.session.userProfile
    let access_token = LoginRadiusSDK.sharedInstance.session.accessToken
    let alreadyLoggedIn = LoginRadiusSDK.sharedInstance.session.isLoggedIn
```

### Integrate Forgot Password

Following code can used for the implementation of forgot password feature:

This API is used to send the reset password URL to a specified account. Note: If you have the UserName workflow-enabled, you may replace the 'email' parameter with 'username.' Call this function to send a reset password link to the specified account.

```
AuthenticationAPI.shared.forgotPassword(withEmail:"<your email>", emailtemplate:nil,completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Successfully sent email");
            }
        })
```

**Forgot Password By Phone**

Call this function to send a reset password link to the specified number.

```
AuthenticationAPI.shared.forgotPassword(withPhone:"<yourphone>", smstemplate:nil,completionHandler: {(data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Successfully sent")
            }
        })
```

### Integrate Social Login

Social Login can be done in two ways.

1. Web Social Login: This is done using `SFSafariViewController` or `WKWebView`. \
SFSafariViewController is the default choice for authentication. If it is not available, i.e. < iOS 9, social login falls back to WKWebView. \
Note: Facebook and Google no longer allow OAuth requests in embedded browsers on iOS. For Google or Facebook social login to work, you will need to use the Native Social Login implementation method.

2. Native Social Login \
Login is done natively, utilizing the respective provider SDK's.

#### Web Social Login

Social Login with the given provider. Call this function in the view controller you have set up for the button views.

To integrate Web Social Login. Follow the steps

1. Enable [https://auth.lrcontent.com](https://auth.lrcontent.com/) in your site list, please add it under Deployment > Apps > Web Apps for Social Login to work correctly.

2. Whitelist the Apps callback URL where you want to redirect your users after successfuly social login in the Deployment > Apps > Web Apps section of the Admin console. e.g <site-name>.com.loginradius.SwiftDemo://

1. Call `login(withProvider: "", inController: self, completionHandler)` method with the appropriate params in your Application to start Web Social Login. \
For complete list of social login providers: Ref to this [support doc \
](https://www.loginradius.com/docs/getting-started/general-questions/supported-social-networks)Example:

```
LoginRadiusSocialLoginManager.sharedInstance.login(withProvider:"google", inController: self, completionHandler: { (data, error) in
            
            if let err = error {
                print(err.localizedDescription)
            } else {
                let access_token = data!["access_token"] as! String
                print(access_token)
                print("successfully logged in")
              
            }
        })
```

#### Native Social Login

**Apple native login**

For Native Apple login to work, create and configure your apple app as per [loginradius docs](https://www.loginradius.com/docs/api/v2/announcements/sign-in-with-apple/#signin-with-appleid).

Apple sign-in is being done by the Xcode inbuild apple authentication services. This is an inbuilt service that provides Sign in with Apple Feature. By adding the Apple sign in from Xcode prebuild libraries, get added, and for implementing apple sign in for IOS, please follow the below steps.

**Project Configuration** First, set the development team in the Signing & Capabilities tab in your project so Xcode can create a provisioning profile that. If you've already created a project and provisioning profile, then ignore this. After that, click on capability and Add the Sign In with Apple in your project. This will add an entitlement that lets your app use Sign In with Apple.

1. **Add Apple Login Button** AuthenticationServices framework provides ASAuthorizationAppleIDButton to enables users to initiate the Sign In with Apple flow. Adding this button is very simple. You just need to create an instance of ASAuthorizationAppleIDButton and add a target for touchUpInside action. After that, you can add this button in your view.

```
let btnAuthorization = ASAuthorizationAppleIDButton()
btnAuthorization.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
btnAuthorization.center = self.view.center
btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
self.view.addSubview(btnAuthorization)

```


2. **Handle Login Process** Now on the press of Sign In with Apple Button, we need to use a provider (ASAuthorizationAppleIDProvider) to create a request (ASAuthorizationAppleIDRequest), which we then use to initialize a controller (ASAuthorizationController) that performs the request. We can use one or more of ASAuthorization.Scope values in the requested scopes array to request certain contact information from the user.

```

// Perform acton on click of Sign in with Apple button
 @objc func actionHandleAppleSignin() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
}

```


3. **ASAuthorizationController Delegate** AuthorizationController(controller: didCompleteWithAuthorization:) tells the delegate that authorization completed successfully.

```

// ASAuthorizationControllerDelegate function for successful authorization
func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
  if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      // Create an account as per your requirement
      let appleId = appleIDCredential.user
      let appleUserFirstName = appleIDCredential.fullName?.givenName
      let appleUserLastName = appleIDCredential.fullName?.familyName
      let appleUserEmail = appleIDCredential.email
      let appleUserToken = appleIDCredential.authorizationCode as! Data
      if let string = String(bytes: appleUserToken, encoding: .utf8) {
      print(string)
      exchangeAppleToken(code : string)
      } else {
          print("not a valid UTF-8 sequence")
      }
      //Write your code
  } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
      let appleUsername = passwordCredential.user
      let applePassword = passwordCredential.password
      //Write your code
  }
}

```

4. **Exchange LoginRadius Token** After getting Authorization Code from Apple you should exchange the code with LoginRadius with a simple LoginRadius Apple Sign in Native API.

```

func exchangeAppleToken(code : String) {
    //@param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. apple_<social app name> )
     LoginRadiusSocialLoginManager.sharedInstance.convertAppleCodeToLRToken(code: code, withSocialAppName: "", completionHandler: {(data, error) in
        if let _ = data
        {
          //Your Code after LoginRadius Authenticate Apple Code
        }else if let err = error
        {
          //User canceled or errored on LoginRadius Authentication Page
        }
    })
    }
  
  ```

** Note :- **


In the iOS device, if you want to setup multiple social apps for the same social provider then you can provide a unique app name for that provider.This unique social app name will be passed in the native login as a provider name like : + (eg: "apple_myproduct1" )

For more information regarding the apple setup please look the swift demo

**Facebook native login**

For Native Facebook login to work, create and configure your Facebook app as per [facebook docs](https://developers.facebook.com/docs/facebook-login/ios/).

You don't need to download and integrate the Facebook SDK with your project. It is distributed as a dependency with LoginRadius Swift SDK. Just make sure your `Info.plist` looks like this.

![image](https://github.com/lrengineering/swift-sdk-ios-customer-identity-/assets/118890027/82f3fd5f-de49-494c-b113-1f7eee285253)

**If you are using our demo,** then go to our AppDelegate.swift and set **useFacebookNative** to **true** to display our native facebook ui.

**If you are making your app,** then proceed to add these lines of codes in your `AppDelegate.swift`.

```
//  AppDelegate.swift

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var canOpen = false
        canOpen = (canOpen || LoginRadiusSDK.sharedInstance.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))

        return canOpen
    }
Replace the values with your Facebook App ID and Display name from your App Settings page in [Facebook Developer portal](https://developers.facebook.com/)

```

Call the function to start Facebook Native Login.

```
//@param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. facebook_<social app name> )
       LoginRadiusSocialLoginManager.sharedInstance.nativeFacebookLoginWithPermissions(params: ["facebookPermissions": ["public_profile"]], withSocialAppName: "", inController: self, completionHandler : {( data, error) -> Void in           
          if let err = error {
                print(err.localizedDescription)
            } else {
                print("Successfully logged in with facebook")
            }
        })
```

**Google native login**

Google Native Login is done through Google SignIn Library since this is a static library and has problems when you are using CocoaPods with `uses_frameworks!`, you have to manually install the SDK.

Follow these steps:

1. For Google SignIn, you would need a configuration file `GoogleServices-Info.plist.` You can generate one following the steps [here](https://console.developers.google.com/apis/credentials?project=_&refresh=1).

2. Drag the `GoogleService-Info.plist` file you just downloaded into the root of your Xcode project and add it to all targets.

![](/Users/MeghaAgarwal/Downloads/iOS Library Swift_12-04-2024_12_13_57/vBb-enter-image-description.png)
 
 
Replace `{your REVERSED_CLIENT_ID}` with value of `REVERSED_CLIENT_ID` from `GoogleServices-Info.plist` file.

4. Add Google Sign In by following the [documentation](https://developers.google.com/identity/sign-in/ios/sign-in)

5. If you are using our demo, go to our AppDelegate.swift and set **useGoogleNative** to **true** to display our native google ui. Our demo already contain all the necessary code to perform native Google Sign in, you just have to uncomment any instance of `/* Google Native SignIn <code block> */ 
`If you are making your own app, proceed to add these lines of codes. You can also see our demo to see the native google sign in action!

6. Add Google SignIn Library to your `Podfile`. `pod 'Google/SignIn'`

7. Now change your App Delegate's open URL to handle both google native sign in and our default logins


```
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var canOpen = false
        canOpen = (canOpen || LoginRadiusSDK.sharedInstance.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))

        return canOpen
    }
```

8) You have to exchange the Google token with LoginRadius Token. Call the following function in the SignIn delegate method after successful sign in.

```
// Google Native Sign in
 func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
     
     if let err = error
     {
     print("Error: \(err.localizedDescription)")
     }
     else
     {
     let googleToken: String = user.authentication.accessToken
     let refreshToken: String = user.authentication.refreshToken
     let clientID: String = user.authentication.clientID
     if let navVC = self.window?.rootViewController as? UINavigationController,
     let currentVC = navVC.topViewController
     {
     LoginRadiusSocialLoginManager.sharedInstance.convertGoogleTokenToLRToken(googleToken: googleToken, googleRefreshToken: refreshToken, googleClientId: clientID, withSocialAppName: "", inController: currentVC, completionHandler: {( data ,  error) -> Void in
     NotificationCenter.default.post(name: Notification.Name("userAuthenticatedFromNativeGoogle"), object: nil, userInfo: ["data":data as Any,"error":error as Any])
     
     })
     }
     }
     }
```

9) As the final step, add the google native signOut on your logout button.

```
func logoutPressed() {
GIDSignIn.sharedInstance().signOut()
        LoginRadiusSDK.logout()
        let _ = self.navigationController?.popViewController(animated: true)
    }
```

**WeChat native login**

Firstly you will need to apply for a WeChat ID. The English site is at [http://open.wechat.com](http://open.wechat.com/) and the Chinese: [http://open.weixin.qq.com](http://open.weixin.qq.com/). It may only be possible to get the ID using the Chinese site so you will need to enlist the help of a Chinese speaker or Google Translate :stuck_out_tongue_winking_eye: There are also two different versions of the SDK, the Chinese and English version.

For Native WeChat login to work, create and configure please look [wechat official guide](https://developers.weixin.qq.com/doc/oplatform/en/Mobile_App/WeChat_Login/Development_Guide.html)

Wechat Native Login is done through Wechat SignIn Library you can add the library via CocoaPods with use_modular_headers!.

```

pod 'WechatOpenSDK'
```

As there are several Objective-C header (.h) files we need to add them to our projects Bridging Header file, just #import "WXApi.h" will suffice.

We also need to add the URL Scheme. Just go to the Info tab in your project and expand URL Types. Add a type with the identifier weixin and the URL Schemes set to the WeChat AppID you got when registering your app.

Finally right click on the Info.plist and edit source to look like so:
```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

```
This is necessary because iOS9 limits HTTP access.

**Exchange LoginRadius Token** After getting Authorization Code from Apple you should exchange the code with LoginRadius with a simple LoginRadius Wechat Native API.

```
LoginRadiusSocialLoginManager.sharedInstance.convertWeChatCodeToLRToken(code: "code", completionHandler:  {( data, error) -> Void in
            
                        if let err = error {
                            print(err.localizedDescription)
                        } else {
                            print(data)
                        }
                    })

For more details please look the [WeChat Demo](https://github.com/LoginRadius/ios-sdk/tree/wechat-demo).

```

## Biometrics(Face/Touch ID)

Biometric authentication for iOS applications is implemented using the Local Authentication Framework. For detailed information, please refer to the following link

[https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id](https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id)

LoginRadiusSwift SDK contains a helper named **LRBiometrics**. You can use this helper to authenticate using facial and touch id recognition, to enable the biometric authentication using face id you need to include the **[NSFaceIDUsageDescription](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW75)** (Privacy - Face ID Usage Description) key in your app’s Info.plist file. Without this key, the system won’t allow your app to use Face ID. The value for this key is a string that the system presents to the user the first time your app attempts to use Face ID.

| Key | Type | Value |
|---|---|---|
| Privacy - Face ID Usage Description | String | This app uses facial recognition |

Please call the following function for facilitating Face and Touch ID recognition:


```
LRBiometrics.sharedInstance.checkBiometricAvailability { available, error in
            if available {
                print("Biometric is available")
                
                LRBiometrics.sharedInstance.authenticateWithBiometrics(
                    successCompletion: {
                        print("Biometric authentication successful")
                        // Continue with your app logic
                        
                    },
                    failureCompletion: { errorMessage in
                        // Handle authentication failure
                        print("ERROR \(errorMessage)")
                        
                    }
                )
            } else {
                print(error ?? "unknown error")
                // Handle case where biometric is not available
            }
            
        }

```

## Face ID and Touch ID implementation for native iOS applications

Touch ID and Face ID are preferred because these authentication mechanisms let the users access their devices in a secured manner, with minimal efforts. When you adopt the LocalAuthentication framework, you streamline the consumer authentication experience in the typical case while providing a fallback option when biometrics are not available.

Below are the implementation steps to authenticate a user using Face ID or Touch ID :

1. Login a user with email and password leveraging the LoginRadius [Login by Email](https://www.loginradius.com/docs/api/v2/customer-identity-api/authentication/auth-login-by-email/) API in LoginRadius [iOS Swift SDK](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#loginbyemail17).

2. After the successful authentication, the Access Token session will be created and validated as per the [Access Token lifetime](https://adminconsole.loginradius.com/platform-security/account-protection/session-management/token-lifetime) configured for your site.

3. Now you can leverage the below method to store the token and profile value in the session.

```
LRSession.init(token: token as String, userProfile: profile! as! [String:Any])
```

1. You can make your users authenticate using Touch ID or Face ID each time they open the app, and the session will be continued as per their Access Token lifetime.

2. To check if the session already exists or not, use the below method:

```
    let alreadyLoggedIn = LoginRadiusSDK.sharedInstance.session.isLoggedIn
```

4. Now you can implement the Touch ID and Face ID Native Code in your mobile application as per your business requirement.

Refer to the documentation [here](https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id) for more information on logging a user into your application with Touch ID or Face ID.

In the success method, that is called after the success of biometric authentication, you can implement the LoginRadius [Auth Read all Profiles by Token](https://www.loginradius.com/docs/api/v2/customer-identity-api/authentication/auth-read-profiles-by-token/) API and call this API based on the session store token or you may also be able to get the profile as a well using the below method:

```
            let profile = LoginRadiusSDK.sharedInstance.session
            let access_token = LoginRadiusSDK.sharedInstance.session

//We added a small boolean function if you want to check whether the user is logged in or not.

 let isUserLoggedIn = LoginRadiusSDK.sharedInstance.session.isLoggedIn()
```

**Refer to the following flow for user’s experience while interacting with the application:**

1. User runs the application and needs to login via their credentials (email and password).

2. User closes the application and visits the application after some time (say 2 days).

3. After 2 days, the application will ask the user to login again via Face ID or Touch ID.

4. When a user is successfully authenticated with any of these Biometric Authentication methods, then they can proceed to use the application.

## Credential Encryption in Secure Enclave

The Secure Enclave is a hardware-based key manager that’s isolated from the main processor to provide an extra layer of security. Using a secure enclave, we can create the key, securely store the key, and perform operations with the key. Thus makes it difficult for the key to be compromised. For detailed information, please refer to the following link.

[https://support.apple.com/en-in/guide/security/sec59b0b31ff/web](https://support.apple.com/en-in/guide/security/sec59b0b31ff/web)

LoginRadius Swift SDK contains a helper named as SecEnclaveWrapper. You can use this wrapper to encrypt/decrypt sensitive data using Secure Enclave. It provides an extra level of security for Api Credentials inside the SDK using secure enclave encryption, this encryption will encrypt the LoginRadius **ApiKey**, to enable this encryption you need to set **true** for **setEncryption** key into **LoginRadius.plist** .

| Key | Type | Value |
|---|---|---|
| setEncryption | BOOL | YES |

By default, LoginRadius stores ApiKey in a secure enclave but if you want to store access token or some sensitive data.Please call the following function which return the decrypted Data value :

```
if LoginRadiusSDK.setEncryption() {
            let apikey = LoginRadiusSDK.apiKey()
            let key = apikey.data(using: .utf8)!
            let decr = LoginRadiusEncryptor.sharedInstance.encryptDecryptText(data: key)
            let myString = String(data: decr, encoding: .ascii)
            print(myString)
            
        }else{
print("please set setEncryption flag value to true in LoginRadius plist")
}
```

## IP Address

This code retrieves the IP address of your iPhone.

```
 
 func getIPAddress() -> String? 

{
        var address : String?
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                // wifi = ["en0"]
                // wired = ["en2", "en3", "en4"]
                // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
```

## Latitude and Longitude

This method retrieves the current latitude and longitude of the location. Add a key **NSLocationAlwaysUsageDescription** in your info.plist

| Key | Type | Value |
|---|---|---|
| Privacy - Location Always Usage Description | String | App required Location |

```
import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
        override func viewDidLoad() 
   {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

  //Call startUpdatingLocation Method to get the coordinates
           locationManager.startUpdatingLocation()

       
    }
 func locationManager(_ manager: CLLocationManager, didUpdateLocations    locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        locationManager.stopUpdatingLocation()
       
    }
 }
```

## Device OS Version



This code retrieves the current ios version of your iPhone.

```
 func OSVersion()
    {
        let osVersions = UIDevice.current.systemVersion
        print("Device OS Version: \(osVersions)")
    }
```

## Device Type

This code retrieves the **machine code** that represents the model of your iPhone, which indicates the type of device you own.



```
func deviceName() -> String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
```

## Logout

Log out to the user.

```
LoginRadiusSDK.logout()
```

## Access Token and User Profile

After successful login or social login, LoginRadius access token and user profile can be accessed like this.

```
let profile = LoginRadiusSDK.sharedInstance.session.userProfile
let access_token = LoginRadiusSDK.sharedInstance.session.accessToken
```

We added a small boolean function if you want to check whether the user is logged in or not.

```
let isUserLoggedIn = LoginRadiusSDK.sharedInstance.session.isLoggedIn()
```

## Single Sign-On

If you have multiple iOS apps and want to have a single sign-on across all of them, here are the steps to do it with the LoginRadius iOS Swift SDK. Under the hood, we use iOS' keychain to do this.

Add this to your LoginRadius.plist for your apps.

| Key | Type | Value |
|---|---|---|
| useKeychain | BOOL | YES |

Go to your Project Folder -> Capabilities and under Keychain Sharing add your sitename.

![image](https://github.com/lrengineering/swift-sdk-ios-customer-identity-/assets/118890027/15968bd2-7bb5-4a62-9c43-582d9799bd10)

**If you are just testing Single Sign-On on LoginRadius' demo apps, you can stop here.** All the coding implementation is already done in the demo, and you can just try out the swift demo for the functionality.

**If you are creating a fresh new app, continue.** For SSO to work, you need to add a few more things to trigger the sign in when the app is moving from background to foreground. Add NSNotification observer on the view controllers that could log the user in. You can see the examples in swift demo.

```
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This is do when there are 2 apps sharing 1 LoginRadius sitename login
        //If the other app logged in, this logs in too.
        
        if LoginRadiusSDK.sharedInstance.session.isLoggedIn()
        {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showProfileController), name:  UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if LoginRadiusSDK.sharedInstance.session.isLoggedIn()
        {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
```

When the app triggers "UIApplicationWillEnterForegroundNotification" check our accessToken and userProfile to fetch it from the keychain

```
func showProfileController () {
        DispatchQueue.main.async
        {
            if LoginRadiusSDK.sharedInstance.session.isLoggedIn()
            {
                //go to vc after user logged in
            }else
            {
                //failed to logged in
            }
        }
    }
```

Do this with all your iOS apps that use the same site name.

To make your app, other apps logged out when one of your apps logged out. You need to the same observers to the same events on the viewcontrollers that assumes that the user logged in.

```
override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This is do when there are 2 apps sharing 1 LoginRadius sitename login
        //If the other app logged out, this logs out too.
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupForm), name:  UIApplication.willEnterForegroundNotification, object: nil)
        
        setupForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setupForm(){
        guard let userAccessToken = LoginRadiusSDK.sharedInstance.session.accessToken
        else
        {
            self.showAlert(title: "ERROR", message: "Access token is missing or logged out")
            self.logoutPressed()
            return
        }
```



## LoginRadius API Showcase

This section helps you to explore various API methods of LoginRadius IOS Swift SDK. They can be used to fulfill your identity-based needs related to traditional login, registration, social login, and many more.

### Authentication API

This API is used to perform operations on a user account after the user has authenticated himself for the changes to be made. Generally, it is used for front end API calls. Following is the list of methods covered under this API:

1. [Registration By Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#registration-by-email)

2. [Login By Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#login-by-email)

3. [Login By Username](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#login-by-username)

4. [Read Complete User Profile](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#read-complete-user-profile)

5. [Link Social Account](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#link-social-account)

6. [Unlink Social Account](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#unlink-social-account)

7. [Update User Profile](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#update-user-profile)

8. [Check Email Availability](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#check-email-availability)

9. [Add Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#add-email)

10. [Verify Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#verify-email)

11. [Remove Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#remove-email)

12. [Resend Verification Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#resend-verification-email)

13. [Change Password](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#change-password)

14. [Forgot Password By Email Or UserName](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#forgot-password-by-email-or-username)

15. [Validate Access Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#validate-access-token)

16. [Invalidate Access Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#invalidate-access-token)

17. [Get Security Questions By Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#get-security-questions-by-email)

18. [Get Security Questions By Username](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#get-security-questions-by-username)

19. [Get Security Questions By AccessToken](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#get-security-questions-by-accesstoken)

20. [Update Security Questions By AccessToken](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#update-security-questions-by-accesstoken)

21. [Check Username Availability](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#check-username-availability)

22. [Set or Change Username](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#set-or-change-username)

23. [Reset Password By Reset Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-password-by-reset-token)

24. [Reset Password By Security Questions using Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-password-by-security-questions-using-email)

25. [Reset Password By Security Questions using Username](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-password-by-security-questions-using-username)

26. [Auth Verify Email by OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#auth-verify-email-by-otp)

27. [Auth Reset Password by OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#auth-reset-password-by-otp)

28. [Auth Send Welcome Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#auth-send-welcome-email)

29. [Auth Privacy Policy Accept](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#auth-privacy-policy-accept)

30. [Delete Account](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#delete-account)

31. [Delete Account with Email confirmation](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#delete-account-with-email-confirmation)

### Registration By Email

This API creates a user in the database as well as sends a verification email to the user. For all the possible payload fields, please check the Auth User Registration by Email [API](https://www.loginradius.com/docs/api/v2/user-registration/auth-user-registration-by-email)

```
let email:AnyObject = [ "Type":"Primary","Value":"test@gmail.com" ] as AnyObject
        let parameter:AnyObject = [ "Email": [email],
                                    "Password":"password"
                                  ]as AnyObject
  AuthenticationAPI.shared.userRegistration(withSott: sott, payload: parameter as! [String : Any], emailtemplate: nil, smstemplate: nil, preventVerificationEmail: false, completionHandler: { (data, error) in
                    
            if let err = error
                    {
                        print(err.localizedDescription)
                    }else{
                        print("successfully registered");
                    }
            })
```
            
       
 Note  : The referer header is used to determine the **registration source** from which the user has created the account and is synced in the **RegistrationSource** field for the user profile. Add the registrationSource entity in the LoginRadius.plist file as follows to change the registration source of the user in IOS SDK.

![image](https://github.com/lrengineering/swift-sdk-ios-customer-identity-/assets/118890027/79544a5b-a538-45ee-a16f-81bdcc22b585)

##  Login By Email

This API retrieves a copy of the user data based on the Email.

```
let parameter:AnyObject = ["email":email,
                                   "password":password,
                                   "securityanswer":""
                                  ]as AnyObject
  AuthenticationAPI.shared.login(withPayload:parameter as! [String : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
             if let err = error {
                print(err.localizedDescription)
            } else {
                print("login successful") 
            }
      })
```

### **Login By Username**


This API retrieves a copy of the user data based on the Username.

```
 let parameter:AnyObject = ["username":"","password":"",
                                   "securityanswer":""
                                  ]as AnyObject
        AuthenticationAPI.shared.login(withPayload:parameter as! [String : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
             if let err = error {
                print(err.localizedDescription)
            } else {
                print("login successful")
                print(data)
            }
        })

```

### Read Complete User Profile

This API retrieves a copy of the user data based on the access_token.

```
AuthenticationAPI.shared.profiles(withAccessToken:"<access_token>", completionHandler:{ (data, error) in
                if let err = error {
                 print(err.localizedDescription)
                } else {
                 print("success",data)
            }
        })
```

### Link Social Account

This API is called just after account linking API, and it prevents the raas profile of the second account from getting created.

```
AuthenticationAPI.shared.linkSocialIdentities(withAccessToken:"<access_token>", candidatetoken:"<candidatetoken>", completionHandler: {(response, error) in
           if let err = error {
             print(err.localizedDescription)
           } else {
             print(response)
           }
        })
```

### Unlink Social Account

```
AuthenticationAPI.shared.unlinkSocialIdentitiesWithAccessToken(access_token: "<access_token>", provider: "<provider>", providerid: "<providerid>", completionHandler: {(response, error) in
            if let err = error {
               print(err.localizedDescription)
            } else {
               print(response)
            }
        })
```

### Update User Profile

This API is used to update the user profile by the access token. For all the possible payload fields, please check the Auth Update Profile by Token [API](https://www.loginradius.com/docs/api/v2/user-registration/auth-update-profile-by-token)

```
let parameter:AnyObject = ["FirstName":"Test","Gender":"M"
                    ]as AnyObject
        AuthenticationAPI.shared.updateProfileWithAccessToken(access_token: "<access_token>", emailtemplate: nil, smstemplate: nil, payload: parameter as! [String : Any], completionHandler: {(response, error) in
             if let err = error {
                 print(err.localizedDescription)
              } else {
                 print(response)
             }
        })
```

### Check Email Availability

This API is used to check the email exists or not on your site.

```
AuthenticationAPI.shared.checkEmailAvailability("<email>",completionHandler: { (data, error) in
            if let err = error {
               print(err.localizedDescription)
            } else {
               print("success",data as Any)
            }
        })
```

### Add Email

This API is used to add additional emails to a user's account.

```
let parameter:AnyObject = ["email":"xyz@example.com",
                                           "type":"Secondary"
                    ]as AnyObject
        AuthenticationAPI.shared.addEmail(withAccessToken:"<access_token>", emailtemplate:nil, payload:parameter as! [String : Any], completionHandler: { (data, error) in
          if let err = error {
             print(err.localizedDescription)
          } else {
             print("success",data as Any)
          }
         })
```

### Verify Email

This API is used to verify the email of the user.

```
AuthenticationAPI.shared.verifyEmail(withVerificationToken:"<access_token>", url:nil, welcomeemailtemplate:nil,completionHandler: {(response, error) in
            if let err = error {
               print(err.localizedDescription)
            } else {
               print(response)
            }
        })
```

##### Remove Email

This API is used to remove additional emails from a user's account.

```
AuthenticationAPI.shared.removeEmailWithAccessToken(access_token:"<access_token>", email:"<email>",completionHandler: {(response, error) in
            if let err = error {
               print(err.localizedDescription)
            } else {
               print(response)
            }
        })
```

##### Resend Verification Email

This API resends the verification email to the user.

```
AuthenticationAPI.shared.resendEmailVerification("<email>", emailtemplate: nil, completionHandler:{(response, error) in
            if let err = error {
               print(err.localizedDescription)
            } else {
               print(response)
            }
        })
```

##### Change Password

This API is used to change the account's password based on the previous password.

```
AuthenticationAPI.shared.changePassword(withAccessToken:"<access_token>", oldpassword:"<oldpassword>", newpassword:"<newpassword>",completionHandler: {(response, error) in
            if let err = error {
               print(err.localizedDescription)
            } else {
               print(response)
            }
        })
```

##### Forgot Password By Email Or UserName

This API is used to send the reset password URL to a specified account. Note: If you have the UserName workflow-enabled, you may replace the 'email' parameter with 'username.'

```
    AuthenticationAPI.shared.forgotPassword(withEmail:"<your email>", emailtemplate:nil,completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
```

##### Validate Access Token

This api validates the access token, if valid, then returns a response with its expiry otherwise error.

```
AuthenticationAPI.shared.validateAccessToken("<access_token>",  completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Invalidate Access Token

This api call invalidates the active access token or expires an access token's validity.

```
AuthenticationAPI.shared.invalidateAccessToken("<access_token>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Get Security Questions By Email

This API is used to retrieve the list of questions that are configured on the respective LoginRadius site.

```
AuthenticationAPI.shared.getSecurityQuestions(withEmail:"<email>", completionHandler: {(response, error) in
            if let err = error {
              print(err.localizedDescription)
             } else {
            let json = response!["Data"] as! NSArray
            for data in json{
               print(data)
            }
           }
        })
```

##### Get Security Questions By Username

This API is used to retrieve the list of questions that are configured on the respective LoginRadius site.

```
AuthenticationAPI.shared.getSecurityQuestions(withUserName:"<username>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                let json = response!["Data"] as! NSArray
            for data in json{
               print(data)
            }
}
        })
```

##### Get Security Questions By AccessToken

This API is used to retrieve the list of questions that are configured on the respective LoginRadius site.

```
AuthenticationAPI.shared.getSecurityQuestions(withAccessToken:"<access_token>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } 
   let json = response!["Data"] as! NSArray
            for data in json{
               print(data)
            }
        })
```

##### Update Security Questions By AccessToken

This API is used to update security questions by the access token.

```
       let securityquestionanswer:AnyObject = ["<Put Your Security Question ID>":"<Put Your Answer>"] as AnyObject
        let parameter:AnyObject = [  "securityquestionanswer":securityquestionanswer
                                    ]as AnyObject
        AuthenticationAPI.shared.updateSecurityQuestionWithAccessToken(access_token: "<access_token>", payload: parameter as! [String : Any], completionHandler:  {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

##### Check Username Availability

This API is used to check the UserName exists or not on your site.

```
AuthenticationAPI.shared.checkUserNameAvailability("<username>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print(response);
            }
        })
```

##### Set or Change Username

This API is used to set or change UserName by the access token.

```
AuthenticationAPI.shared.changeUserNameWithAccessToken(access_token: "<access_token>", username: "<username>", completionHandler:{(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Reset Password By Reset Token

This API is used to set a new password for the specified account.

```
let parameter:AnyObject = [
                                    "resettoken":"",
                                    "password":"",
                                    "welcomeemailtemplate":"",
                                    "resetpasswordemailtemplate":""
                                    ]as AnyObject
  
 AuthenticationAPI.shared.resetPasswordByResetToken(parameter as! [String : Any], completionHandler:{(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Reset Password By Security Questions using Email

This API is used to reset the password for the specified account by a security question.

```
let securityquestionanswer:AnyObject = ["<Put Your Security Question ID>":"<Put Your Answer>"] as AnyObject
                 let parameter:AnyObject = [
                     "securityanswer": securityquestionanswer,
                     "email":"",
                     "password":"",
                     "resetpasswordemailtemplate":""]as AnyObject
        AuthenticationAPI.shared.resetPasswordBySecurityAnswerAndEmail(parameter as! [String : Any], completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

##### Reset Password By Security Questions using Username

This API is used to reset the password for the specified account by a security question.

```
let securityquestionanswer:AnyObject = ["<Put Your Security Question ID>":"<Put Your Answer>"] as AnyObject
                 let parameter:AnyObject = [
                     "securityanswer": securityquestionanswer,
                     "username":"",
                     "password":"",
                     "resetpasswordemailtemplate":""]as AnyObject
        AuthenticationAPI.shared.resetPasswordBySecurityAnswerAndUserName(payload: parameter as! [String:Any], completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Auth Verify Email by OTP

This API is used to verify the email of the user when the OTP Email verification flow is enabled, and please note that you must contact LoginRadius to have this feature enabled.

```
let securityquestionanswer:AnyObject = ["<Put Your Security Question ID>":"<Put Your Answer>"] as AnyObject
        let payload:AnyObject = ["otp":"",
                                "email":""
            ]as AnyObject
        AuthenticationAPI.shared.verifyEmailByOtpWithPayload(payload: payload as! [String : Any], url:"", welcomeemailtemplate:"", completionHandler:{ (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Email verification success")
            }
        })
```

##### Auth Reset Password by OTP

This API is used to set a new password for the specified account.

```
let payload:AnyObject = [
                "password": "xxxxxxxxxxxxx",
                "welcomeemailtemplate": "",
                "resetpasswordemailtemplate": "",
                "Email": "",
                "Otp": ""
                ]as AnyObject
        AuthenticationAPI.shared.resetPasswordByOtpWithPayload(payload: payload as! [String : Any], completionHandler: { (data, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    print("Password reset success")
                }
        })
```

##### Auth Send Welcome Email

This API will send a welcome email.

```
AuthenticationAPI.shared.sendWelcomeEmail(withAccessToken:"<access_token>", welcomeemailtemplate:"", completionHandler:{ (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Welcome email send success")
            }
        })
```

##### Auth Privacy Policy Accept

This API is used to update the privacy policy stored in the user's profile by providing the access_token of the user accepting the privacy policy.

```
AuthenticationAPI.shared.privacyPolicyAccept(withAccessToken:"<access_token>", completionHandler:{ (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Privacy policy update success")
            }
        })
```

##### Delete Account

This API is used to delete the account using a delete token.

```
AuthenticationAPI.shared.deleteAccount(withDeleteToken:"<deletetoken>",  completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Delete Account with Email confirmation

API deletes the user account by the access token.

```
AuthenticationAPI.shared.deleteAccountWithEmailConfirmation(access_token: "<access_token>", emailtemplate: nil, completionHandler: {(response, error) in
            
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

### Phone Authentication API

This API is used to perform operations on a user account by Phone after the user has authenticated himself for the changes to be made. Generally, it is used for front end API calls. Following is the list of methods covered under this API:

1. [Registration By Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#registration-by-phone)

2. [Login By Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#login-by-phone)

3. [Forgot Password By Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#forgot-password-by-phone)

4. [Phone ResetPassword By Otp](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-resetpassword-by-otp)

5. [Check Phone Availability](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#check-phone-availability)

6. [Phone Resend OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-resend-otp)

7. [Phone Resend OTP By Access Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-resend-otp-by-access-token)

8. [Phone Verify OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-verify-otp)

9. [Phone Verify OTP By Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-verify-otp-by-token)

10. [Get Security Questions By Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#get-security-questions-by-phone)

11. [Update Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#update-phone)

12. [Reset Password By Security Questions using Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-password-by-security-questions-using-phone)

13. [Remove Phone ID by Access Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#remove-phone-id-by-access-token)

##### Registration By Phone

This API registers the new users into your Cloud Directory and triggers the phone verification process. For all the possible payload fields, please check the Auth User Registration by Phone [API](https://www.loginradius.com/docs/api/v2/user-registration/phone-user-registration-by-sms)

```
let parameter:AnyObject = [ "PhoneId": "xxxxxxx",
                                    "Password":"password"
                                  ]as AnyObject
        AuthenticationAPI.shared.userRegistration(withSott:sott,payload:parameter as! [String : Any], emailtemplate:"", smstemplate:"",preventVerificationEmail:false, completionHandler: { (data, error) in
                if let err = error
                {
                    print(err.localizedDescription)
                }else{
                    print("successfully registered");
                }
        })
```

##### Login By Phone

This API retrieves a copy of the user data based on the Phone.

```
let parameter:AnyObject = ["phone":"",
                                  "password":"",
                                  "securityanswer":""
                                ]as AnyObject
        AuthenticationAPI.shared.login(withPayload:parameter as! [String : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
             if let err = error {
                print(err.localizedDescription)
            } else {
                print("login successful")
            }
        })
```

##### Forgot Password By Phone

This API is used to send the OTP to reset the account password.

```
AuthenticationAPI.shared.forgotPassword(withPhone:"<your phone>", smstemplate:nil,completionHandler: {(data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Successfully sent email");
            }
        })
```

##### Phone ResetPassword By Otp

This API is used to reset the password.

```
let parameter:AnyObject = [
                "phone":"",
                "otp":"",
                "password":"",
                "smstemplate":"",
                "resetpasswordemailtemplate":""
                ]as AnyObject
        AuthenticationAPI.shared.phoneResetPasswordByOtpWithPayload(payload: parameter as! [String:Any], completionHandler:{ (data, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    print("Password reset success")
                }
        })
```

##### Check Phone Availability

This API is used to check the Phone Number exists or not on your site.

```
AuthenticationAPI.shared.phoneNumberAvailability("<phone>",  completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Phone Resend OTP

This API is used to resend a verification OTP to verify a user's Phone Number. The user will receive a verification code that they will need to input.

```
 AuthenticationAPI.shared.resendOtp(withPhone:"<phone>", smstemplate:nil, completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

##### Phone Resend OTP By Access Token

This API is used to resend a verification OTP to verify a user's Phone Number in cases in which an active token already exists.

```
AuthenticationAPI.shared.resendOtp(withAccessToken:"<access_token>", smstemplate: nil, completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Phone Verify OTP

This API is used to validate the verification code sent to verify a user's phone number.

```
     AuthenticationAPI.shared.phoneVerificationWithOtp(otp: "<otp>", phone: "<phone>", smstemplate: nil, completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Phone Verify OTP By Token

This API is used to consume the verification code sent to verify a user's phone number. Use this call for front-end purposes in cases where the user is already logged in by passing the user's access token.

```
AuthenticationAPI.shared.phoneVerificationOtpWithAccessToken(access_token: "<access_token>", otp: "<otp>", smstemplate: nil, completionHandler:{(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Get Security Questions By Phone

This API is used to retrieve the list of questions that are configured on the respective LoginRadius site.

```
AuthenticationAPI.shared.getSecurityQuestions(withPhone:"<phone>",completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

##### Update Phone

This API is used to update the login Phone Number of users.

```
AuthenticationAPI.shared.phoneNumberUpdateWithAccessToken(access_token: "<access_token>", phone: "<phone>", smstemplate: nil, completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

##### Reset Password By Security Questions using Phone

This API is used to reset password for the specified account by security question.

```
let securityquestionanswer:AnyObject = ["<Put Your Security Question ID>":"<Put Your Answer>"] as AnyObject
                 let parameter:AnyObject = [
                     "securityanswer": securityquestionanswer,
                     "phone":"",
                     "password":"",
                     "resetpasswordemailtemplate":""]as AnyObject
        AuthenticationAPI.shared.resetPasswordBySecurityAnswerAndPhone(payload: parameter as! [String:Any], completionHandler:  {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
            }
        })
```

##### Remove Phone ID by Access Token

This API is used to delete the Phone ID on a user's account via the access_token

```
AuthenticationAPI.shared.removePhoneIDWithAccessToken(access_token: "<access_token>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print(response)
            }
        })
```

### Custom Object API

This API is used to create additional custom fields for user registration. It provides methods for creating, updating and deleting custom objects. Following is the list of methods covered under this API:

1. [Create Custom Object](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#create-custom-object)

2. [Read Custom Object By Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#read-custom-object-by-token)

3. [Read Custom Object By Record ID](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#read-custom-object-by-record-id)

4. [Update Custom Object](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#update-custom-object)

5. [Delete Custom Object](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#delete-custom-object)

##### Create Custom Object

This API is used to write information in JSON format to the custom object for the specified account.

```
let parameter:AnyObject = [
                                    "customdata1":"Store my customdata1 value",
                                    "customdata2":"Store my customdata2 value"
                                    ]as AnyObject
        CustomObjectAPI.customInstance.createCustomObject(withObjectName:"<objectname>", accessToken:"access_token", payload:parameter as! [String : Any], completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Read Custom Object By Token

This API is used to retrieve the Custom Object data for the specified account.

```
CustomObjectAPI.customInstance.getCustomObject(withObjectName:"<objectname>", accessToken:"<access_token>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print(response)
            }
        })
```

##### Read Custom Object By Record ID

This API is used to retrieve the Custom Object data for the specified account.

```
CustomObjectAPI.customInstance.getCustomObject(withObjectRecordId:"<objectrecordid>", accessToken:"<access_token>", objectname:"<objectname>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success")
       print(response)
            }
        })
```

##### Update Custom Object

This API is used to update the specified custom object data of the specified account. If the value of updatetype is 'replace', then it will fully replace the custom object with the new custom object, and if the value of updatetype is 'partialreplace', then it will perform an upsert type operation.

```
let parameter:AnyObject = [
                                    "field1": "Store my field1 value",
                                    "field2": "Store my field2 value"
                                    ]as AnyObject
        CustomObjectAPI.customInstance.updateCustomObject(withObjectName:"<objectname>", accessToken:"<access_token>", objectRecordId:"<objectrecordid>",updatetype:"<updatetype>", payload:parameter as! [String : Any], completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Success");
            }
        })
```

##### Delete Custom Object

This API is used to remove the specified Custom Object data using ObjectRecordId of a specified account.

```
CustomObjectAPI.customInstance.deleteCustomObject(withObjectRecordId:"<objectrecordid>", accessToken:"<access_token>", objectname:"<objectname>", completionHandler: {(response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
print(response)
  print("Success")
            }
        })
```

### PIN Authentication API

PIN Authentication is a mechanism for prompting your customers to provide a PIN code as part of your Authentication processes.

1. [Login By PIN](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#login-by-pin)

2. [Set PIN By PinAuthToken](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#set-pin-by-pinauthtoken)

3. [Forgot PIN By Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#forgot-pin-by-email)

4. [Forgot PIN By Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#forgot-pin-by-phone)

5. [Forgot PIN By UserName](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#forgot-pin-by-username)

6. [Invalidate PIN Session Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#invalidate-pin-session-token)

7. [Reset PIN By Email and OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-email-and-otp)

8. [Reset PIN By UserName and OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-username-and-otp)

9. [Reset PIN By Phone and OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-phone-and-otp)

10. [Reset PIN By ResetToken](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-resettoken)

11. [Reset PIN By SecurityAnswer and Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-securityanswer-and-email)

12. [Reset PIN By SecurityAnswer and UserName](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-securityanswer-and-username)

13. [Reset PIN By SecurityAnswer and Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#reset-pin-by-securityanswer-and-phone)

14. [Change PIN By Access Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#change-pin-by-access-token)

##### Login By PIN

Use this endpoint to allow customers to login by providing their PIN.

```
 let payload:AnyObject = ["pin":""]as AnyObject
        PinAuthentication.shared.loginWithPin(session_token: "session_token", payload: payload as! [String:Any], completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Pin Login success")
            }
        })
```

##### Set PIN By PinAuthToken

Use this Endpoint to allow your customers to change their PIN using a PIN Auth Token.

```
PinAuthentication.shared.setPinWithPinAuthToken(pinAuthToken: "pinauthtoken", pin:"pin", completionHandler:{ (data, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("pin set success")
                    }
                })
```

##### Forgot PIN By Email

Use this Endpoint to trigger the Forgot PIN process, where an email is sent to the customer.

```
PinAuthentication.shared.forgotPinWithEmail(email:"email", emailtemplate:"emailtemplate", resetpinurl:"resetpinurl",completionHandler:{ (data, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("forgot pin by email success")
                    }
                })
```

##### Forgot PIN By Phone

Use this Endpoint to trigger the Forgot PIN process, where an SMS is sent to the customer with a One Time Passcode (OTP) to use in order to change their PIN.

```
PinAuthentication.shared.forgotPinWithPhone(phone:"phone", smstemplate:"smstemplate",
                completionHandler:{ (data, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("forgot pin by phone success")
                    }
                })
```

##### Forgot PIN By UserName

Use this Endpoint to trigger the Forgot PIN process, where an email is sent to the customer.

```
PinAuthentication.shared.forgotPinWithUserName(username:"username", emailtemplate:"emailtemplate", resetpinurl:"resetpinurl",completionHandler:{ (data, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("forgot pin by username success")
                    }
                })
```

##### Invalidate PIN Session Token

Use this endpoint to invalidate session tokens that have been created as part of the PIN workflows.

```
PinAuthentication.shared.invalidatePinSessionToken(session_token: "session_token", completionHandler:{ (data, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("invalidate pin session_token success")
                    }
                })
```

##### Reset PIN By Email and OTP

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the Email and OTP.

```
let payload:AnyObject = ["pin":"",
                                 "otp":"",
                                 "email":""]as AnyObject
        PinAuthentication.shared.resetPinWithEmailAndOtp(payload: payload as! [String : Any], completionHandler:{ (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("reset pin with email and otp success")
            }
        })
```

##### Reset PIN By UserName and OTP

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the username and OTP.

```
  let payload:AnyObject = ["pin":"",
                                 "otp":"",
                                 "username":""]as AnyObject
        PinAuthentication.shared.resetPinWithUserNameAndOtp(payload: payload as! [String:Any], completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("reset pin with username and otp success")
            }
        })
```

##### Reset PIN By Phone and OTP

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the Phone and OTP.

```
let payload:AnyObject = ["pin":"",
                                 "otp":"",
                                 "phone":""]as AnyObject
        PinAuthentication.shared.resetPinWithPhoneAndOtp(payload: payload as! [String:Any], completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("reset pin with phone and otp success")
            }
        })
```

##### Reset PIN By ResetToken

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the ResetToken.

```
let payload:AnyObject = ["pin":"",
                          "ResetToken":""]as AnyObject
        PinAuthentication.shared.resetPinWithResetToken(payload: payload as! [String:Any], completionHandler: { (data, error) in
        if let err = error {
        print(err.localizedDescription)
        } else {
        print("reset pin with resettoken success")
        }
        })
```

##### Reset PIN By SecurityAnswer and Email

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the SecurityAnswer and Email on the account.

```
let payload:[String: Any] = ["pin":"",
                                         "email":"",
                                         "securityanswer":[
                        "QuestionId": "Answer"]]
        PinAuthentication.shared.resetPinWithSecurityAnswerAndEmail(payload: payload as [String : Any], completionHandler:  { (data, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    } else {
                        print("reset pin with email and securityanswer success")
                    }
                })
```

##### Reset PIN By SecurityAnswer and UserName

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the SecurityAnswer and UserName on the account.

```
let payload:[String: Any]= ["pin":"",
                                 "username":"",
                                 "securityanswer":[
                "QuestionId": "Answer"]]
        PinAuthentication.shared.resetPinWithSecurityAnswerAndUserName(payload: payload as! [String:Any], completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("reset pin with username and securityanswer success")
            }
        })
```

##### Reset PIN By SecurityAnswer and Phone

Use this Endpoint to complete the forgot PIN Process by setting a new PIN on the account by providing the SecurityAnswer and Phone on the account.

```
let payload:[String: Any]= ["pin":"",
                                 "phone":"",
                                 "securityanswer":[
                "QuestionId": "Answer"]]
        PinAuthentication.shared.resetPinWithSecurityAnswerAndPhone(payload: payload as! [String:Any], completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("reset pin with phone and securityanswer success")
            }
        })
```

##### Change PIN By Access Token

Use this Endpoint to allow the customer to change their PIN (Provided that they know the existing PIN) and are logged in with a valid access_token.

```
let payload:AnyObject = ["oldpin":"",
                                 "newpin":""]as AnyObject
        PinAuthentication.shared.changePinWithAccessToken(access_token: "access_token", payload: payload as! [String:Any], completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("change pin with access_token success")
            }
        })
```

### One Touch Login API

This API is used to simplify the registration process to the minimum steps. It is really useful when there is a need to avoid hassles related to user registration. Following is the list of methods covered under this API:

1. [One Touch Login by Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#one-touch-login-by-email)

2. [One Touch Login by Phone](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#one-touch-login-by-phone)

3. [One Touch Email Verification](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#one-touch-email-verification)

4. [One Touch OTP Verification](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#one-touch-otp-verification)

5. [One Touch Login Ping](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#one-touch-login-ping)

##### One Touch Login by Email

This API is used to send a link to a specified email for a frictionless login/registration.

```
 let payload:AnyObject = [
            "clientguid":"",
            "email":"",
            "qq_captcha_ticket":"",
            "qq_captcha_randstr":"",
            "g-recaptcha-response":""
            ]as AnyObject
        OneTouchLoginAPI.shared.oneTouchLoginEmail(payload: payload as! [String:Any], redirectUrl: "", oneTouchLoginEmailTemplate: "", welcomeEmailTemplate: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### One Touch Login by Phone

This API is used to send one time password to a given phone number for a frictionless login/registration.

```
let payload:AnyObject = [
                    "phone":"",
                    "name":"",
                    "qq_captcha_ticket":"",
                    "qq_captcha_randstr":"",
                    "g-recaptcha-response":""
                    ]as AnyObject
        OneTouchLoginAPI.shared.oneTouchLoginPhone(payload: payload as! [String: Any], smstemplate: "", completionHandler:{ (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### One Touch Email Verification

This API verifies the provided token for One Touch Login.

```
OneTouchLoginAPI.shared.oneTouchEmailVerification(verificationtoken: "<verificationtoken>", welcomeemailtemplate: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### One Touch OTP Verification

This API is used to verify the otp for One Touch Login.

```
OneTouchLoginAPI.shared.oneTouchLoginVerification(otp: "<otp>", phone: "<phone>", smstemplate: "", completionHandler: { (data, error) in
              if let err = error {
                  print(err.localizedDescription)
              } else {
                  print("success")
              }
        })
```

##### One Touch Login Ping

This API is used to check if the One Touch Login link has been clicked or not.

```
OneTouchLoginAPI.shared.oneTouchLoginPing(clientguid: "<clientguid>", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

### Smart Login API

The LoginRadius Smart Login set of APIs that do not require a password to login and are designed to help you delegate the authentication process to a different device. This type of Authentication workflow while not limited to, is common among Smart TV apps, Smart Phone Apps and IoT devices. Following is the list of methods covered under this API:

1. [Smart Login By Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#smart-login-by-email)

2. [Smart Login By UserName](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#smart-login-by-username)

3. [Smart Login Ping](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#smart-login-ping)

4. [Smart Login Verify Token](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#smart-login-verify-token)

##### Smart Login By Email

This API sends a Smart Login link to the user's Email Id.

```
  SmartLoginAPI.shared.smartLoginWithEmail(email: "<email>", clientguid: "", smartloginemailtemplate: "", welcomeemailtemplate: "", redirecturl: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Smart Login By UserName

This API sends auto login link to the user's Email Id.

```
  SmartLoginAPI.shared.smartLoginWithUsername(username: "<username>", clientguid: "", smartloginemailtemplate: "", welcomeemailtemplate: "", redirecturl: "", completionHandler:{ (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Smart Login Ping

This API is used to check if the Smart Login link has been clicked or not.

```
 SmartLoginAPI.shared.smartLoginPingWithClientguid(clientguid: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Smart Login Verify Token

This API verifies the provided token for Smart Login.

```
SmartLoginAPI.shared.smartAutoLoginWithVerificationToken(verificationtoken: "verificationtoken", welcomeemailtemplate: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

### Passwordless Login API

This API is used for implementing Passwordless login. It includes methods for sending instant login links through email and username. Also, they allow to verify those links. Following is the list of methods covered under this API:

1. [Passwordless Login By Email](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#passwordless-login-by-email)

2. [Passwordless Login By Username](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#passwordless-login-by-username)

3. [Passwordless Login Verification](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#passwordless-login-verification)

4. [Phone Send OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-send-otp)

5. [Phone Login Using OTP](https://www.loginradius.com/docs/libraries/mobile-sdk-libraries/ios-library/#phone-login-using-otp)

##### Passwordless Login By Email

This API is used to send a Passwordless Login verification link to the provided Email ID.

```
   PasswordlessLoginAPI.shared.passwordlessLoginWithEmail(email: "<email>", passwordlesslogintemplate: "", verificationurl: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Passwordless Login By Username

This API is used to send a Passwordless Login Verification Link to a user by providing their UserName.

```
PasswordlessLoginAPI.shared.passwordlessLoginWithUserName(username: "<username>", passwordlesslogintemplate: "", verificationurl: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Passwordless Login Verification

This API is used to verify the Passwordless Login verification link.

```
PasswordlessLoginAPI.shared.passwordlessLoginVerificationWithVerificationToken(verificationtoken: "<verificationtoken>", welcomeemailtemplate: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Phone Send OTP

This API can be used to send a One-time Passcode (OTP) provided that the account has a verified PhoneID.

```
PasswordlessLoginAPI.shared.passwordlessLoginSendOtpWithPhone(phone: "phone", smstemplate: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

##### Phone Login Using OTP

This API verifies an account by OTP and allows the user to login.

```
let securityquestionanswer:AnyObject = ["<Put Your Security Question ID>":"<Put Your Answer>"] as AnyObject
        let payload:AnyObject = [
            "phone":"",
            "otp":"",
            "qq_captcha_ticket":"",
            "qq_captcha_randstr":"",
            "g-recaptcha-response":""
            ]as AnyObject
        PasswordlessLoginAPI.shared.passwordlessPhoneLoginWithPayload(payload: payload as! [String:Any], smstemplate: "", completionHandler: { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("success")
            }
        })
```

### Configuration API

This API is used to get information about the configuration on the LoginRadius site. Following is the method covered in this API:

```
ConfigurationAPI.configInstance.getConfigurationSchema { data, error in
             if let err = error {
                print(err.localizedDescription)
            } else {
                // To set LoginRadius Schema (The one that you configured in the LoginRadius Admin Console) through:
                  LoginRadiusSchema.sharedInstance.setSchema(data!)
                  // To get LoginRadius Social schema (The one that you configured in the LoginRadius Admin Console) through:
                 if let providersObj = data!["SocialSchema"]{
                   let  fields:[LoginRadiusField] = LoginRadiusSchema.sharedInstance.providers!
                   let providersList: NSMutableArray = NSMutableArray()
                   for field in fields{
                     providersList.add(field.providerName)
                    }
                print(providersList as![String])
                // To get LoginRadius Registration schema (The one that you configured in the LoginRadius Admin Console) through:
                let rFields:[LoginRadiusField] = LoginRadiusSchema.sharedInstance.fields!
                print("Success",rFields)
            }
        }
        }
```

*You can access the LoginRadius Registration schema (The one that you configured in the LoginRadius Admin Console) through:*

```
let rFields:[LoginRadiusField] = LoginRadiusSchema.sharedInstance.fields!
```

## Demo

Link to Demo app

The demo app contains implementations of social login and user registration service.

Steps to setup Demo apps.

1. Clone the SDK repo. Link

2. Run `pod install`

3. Create a plist file named LoginRadius.plist and add it to the demo project.

4. Add your Sitename and API key in LoginRadius.plist

5. For Native social login to work follow the Social Login guide above.
