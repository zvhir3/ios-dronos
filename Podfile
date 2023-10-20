platform :ios, '13.0'

target 'DronosUTM' do
  use_frameworks!
  pod 'DJI-SDK-iOS', '~> 4.16.2'
  pod 'DJI-UXSDK-iOS', '~> 4.16.2'
  pod 'DJIWidget', '~> 1.6.8'
  pod 'DJIFlySafeDatabaseResource', '~> 01.00.01.18'
  pod 'iOS-Color-Picker'
  pod 'MapboxMaps', '10.14.0'
  pod 'CocoaMQTT'
  pod 'CocoaMQTT/WebSockets'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RealmSwift'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
          end
      end
  end    
end

