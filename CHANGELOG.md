4.0.0-beta Release notes (2017-03-08)
=============================================================

### API breaking changes

* Registration through hosted pages is removed, it is done through API.
* Registration Service uses LoginRadius APIv2.
* URL Scheme is now <sitename>.<app bundle id> to support mobile ios sso

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
