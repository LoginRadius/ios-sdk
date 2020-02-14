# WechatExample
Wechat SDK example for login and exchanging the LoginRadius AccessToken.

# installation

- install the cocoapods 'gem install cocoapods'

- run the 'pod install' command.

 
# configuration

First you need to add a URL Schemes to your project.
Go to your **project configuration** > **Info.Plist** > then the **URL schemes** and add must be your wechat appId in wechat_app_ID section.

To use your own **wechat credential** (*appID and UNIVERSAL_LINK) information, you need to change the top of the file **AuthWechatManager.m**, with your informations : 


For Initialize the LoginRadius SDK Create a new File LoginRadius.plist and add it to the demo App and add the apiKey and siteName for the interacting the LoginRadius API.

