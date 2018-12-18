use_frameworks!

workspace 'LoginRadiusSDK'

platform :ios, '9.0'

target 'ObjCDemo' do
    project 'Example/ObjCDemo/ObjCDemo.xcodeproj'
    pod 'LoginRadiusSDK', :path => './'
    pod 'XLForm', '<= 3.3.0'
    #pod 'Google/SignIn', '<= 4.1.0'
    #pod 'TwitterKit', '<= 3.1.1'
end

target 'SwiftDemo' do
    project 'Example/SwiftDemo/SwiftDemo.xcodeproj'
    pod 'LoginRadiusSDK', :path => './'
    pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git'
    pod 'SwiftyJSON', '<= 3.1.4'
    pod 'Alamofire', '<= 4.4.0'
    #pod 'Google/SignIn', '<= 4.1.0'
    #pod 'TwitterKit', '<= 3.1.1'
    
    post_install do |installer|
    myTargets = ['Eureka']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end

end
