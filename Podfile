use_frameworks!

workspace 'LoginRadiusSDK'

platform :ios, '9.0'

target 'ObjCDemo' do
    project 'Example/ObjCDemo/ObjCDemo.xcodeproj'
    pod 'LoginRadiusSDK', :path => './'
    # pod 'Google/SignIn'
    # Uncomment the above line to enable Google Native SignIn
    # Add 'GoogleService-Info.plist' to the xcode project
    # Uncomment the whole xcode project that contains 'Google Native SignIn' comment block
    # Go to https://docs.loginradius.com/api/v1/mobile-libraries/ios-library#nativesociallogin13 for full details

end

target 'SwiftDemo' do
    project 'Example/SwiftDemo/SwiftDemo.xcodeproj'
    pod 'LoginRadiusSDK', :path => './'
    pod 'Eureka'
    pod 'SwiftyJSON',       :git => 'https://github.com/IBM-Swift/SwiftyJSON.git', :branch => 'master'
   # pod 'Google/SignIn'
   # Uncomment the above line to enable Google Native SignIn
   # Add 'GoogleService-Info.plist' to the xcode project
   # Uncomment the whole xcode project that contains 'Google Native SignIn' comment block
   # Go to https://docs.loginradius.com/api/v1/mobile-libraries/ios-library#nativesociallogin13 for full details
end
