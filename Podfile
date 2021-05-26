source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'  # https://github.com/RxSwiftCommunity/RxOptional
  pod 'RxSwiftExt'  # https://github.com/RxSwiftCommunity/RxSwiftExt
  # Log
  pod 'CocoaLumberjack/Swift'  # https://github.com/CocoaLumberjack/CocoaLumberjack
  pod 'R.swift'  # https://github.com/mac-cain13/R.swift
  pod 'SwifterSwift', '~> 5.2'  # https://github.com/SwifterSwift/SwifterSwift
  pod 'SwiftDate'  # https://github.com/malcommac/SwiftDate

  # Keychain
  pod 'KeychainAccess', '~> 4.2.2'  # https://github.com/kishikawakatsumi/KeychainAccess
end

target 'MonstarHub' do
  
  shared_pods
  pod 'RxFlow'
  pod 'Reusable'
  pod 'RxViewController'
  pod 'ReachabilitySwift'
  
  # Rx Extensions
  pod 'RxDataSources'  # https://github.com/RxSwiftCommunity/RxDataSources
  pod 'NSObject+Rx'  # https://github.com/RxSwiftCommunity/NSObject-Rx
  pod 'RxViewController'  # https://github.com/devxoul/RxViewController
  pod 'RxGesture'  # https://github.com/RxSwiftCommunity/RxGesture
  pod 'RxTheme'  # https://github.com/RxSwiftCommunity/RxTheme

  # Date
  pod 'DateToolsSwift'  # https://github.com/MatthewYork/DateTools
  
  # Tools
  pod 'SwiftLint'  # https://github.com/realm/SwiftLint
  
  # UI
  pod 'ImageSlideshow/Kingfisher'  # https://github.com/zvonicek/ImageSlideshow
  pod 'DZNEmptyDataSet'  # https://github.com/dzenbot/DZNEmptyDataSet
  pod 'Localize-Swift'  # https://github.com/marmelroy/Localize-Swift
  pod 'RAMAnimatedTabBarController'  # https://github.com/Ramotion/animated-tab-bar
  pod 'KafkaRefresh'  # https://github.com/OpenFeyn/KafkaRefresh
  pod 'Highlightr'  # https://github.com/raspu/Highlightr
  pod 'DropDown'  # https://github.com/AssistoLab/DropDown
  pod 'Toast-Swift'  # https://github.com/scalessec/Toast-Swift
  pod 'HMSegmentedControl'  # https://github.com/HeshamMegid/HMSegmentedControl
  pod 'FloatingPanel'  # https://github.com/SCENEE/FloatingPanel
  pod 'Charts'  # https://github.com/danielgindi/Charts

  # Code Quality
  pod 'FLEX', :configurations => ['Dev-Debug']  # https://github.com/Flipboard/FLEX
  pod 'BonMot'  # https://github.com/Rightpoint/BonMot
  
  # Analytics
  pod 'Mixpanel-swift'  # https://github.com/mixpanel/mixpanel-iphone
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  # Ads
  pod 'Google-Mobile-Ads-SDK'

  target 'MonstarHubTests' do
    inherit! :search_paths
    
  end

  target 'MonstarHubUITests' do
    
  end

end

target 'Domain' do
  
  shared_pods

  target 'DomainTests' do

  end

end

target 'NetworkPlatform' do
  
  shared_pods
  # Networking
    pod 'Moya/RxSwift', '~> 14.0.0'  # https://github.com/Moya/Moya
    pod 'Apollo'  # https://github.com/apollographql/apollo-ios
    
    # JSON Mapping
    pod 'Moya-ObjectMapper/RxSwift', '~> 2.9.0'  # https://github.com/ivanbruel/Moya-ObjectMapper
  
  target 'NetworkPlatformTests' do
  
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'Yes'
    end
  end
  
  # Cocoapods optimization, always clean project after pod updating
  Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
      flag_name = File.basename(script, ".sh") + "-Installation-Flag"
      folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      file = File.join(folder, flag_name)
      content = File.read(script)
      content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
      File.write(script, content)
  end
  
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
    
    target.build_configurations.each do |config|
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
