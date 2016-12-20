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