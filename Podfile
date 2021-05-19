
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'

target 'Candy' do

use_modular_headers!
#use_frameworks!
inhibit_all_warnings!

 # OC
pod 'FDFullscreenPopGesture' # https://github.com/forkingdog/FDFullscreenPopGesture
pod 'UITableView+FDTemplateLayoutCell' # https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
# page
pod 'JXCategoryView' # https://github.com/pujiaxin33/JXCategoryView
# Video Player
pod 'ZFPlayer'
pod 'ZFPlayer/ijkplayer' # https://github.com/renzifeng/ZFPlayer
pod 'ZFPlayer/ControlView'
# Search
pod 'PYSearch' # https://github.com/ko1o/PYSearch
# Refresh
pod 'MJRefresh' # https://github.com/CoderMJLee/MJRefresh

 # Swift

# RxSwift
pod 'RxNetwork' # https://github.com/Pircate/RxNetwork
pod 'RxNetwork/Cacheable' # https://github.com/Pircate/RxNetwork
pod 'RxActivityIndicator' # https://github.com/InsectQY/RxActivityIndicator
pod 'NSObject+Rx' # https://github.com/RxSwiftCommunity/NSObject-Rx
pod 'RxDataSources' # https://github.com/RxSwiftCommunity/RxDataSources
pod 'RxURLNavigator' # https://github.com/InsectQY/RxURLNavigator
pod 'RxOptional' # https://github.com/RxSwiftCommunity/RxOptional
pod 'RxMJ', :git => 'https://github.com/InsectQY/RxMJ.git' # https://github.com/srv7/RxMJ
pod 'RxReachability' # https://github.com/RxSwiftCommunity/RxReachability

# UIImage Download
pod 'Kingfisher' # https://github.com/onevcat/Kingfisher
pod "KingfisherWebP" # https://github.com/Yeatse/KingfisherWebP
# Codable
pod 'CleanJSON' # https://github.com/Pircate/CleanJSON
# Keyboard
pod 'IQKeyboardManagerSwift' # https://github.com/hackiftekhar/IQKeyboardManager
# HUD
pod 'NVActivityIndicatorView/Extended' # https://github.com/ninjaprox/NVActivityIndicatorView
# Transitions
pod 'Hero' # https://github.com/HeroTransitions/Hero
pod 'Jelly' # https://github.com/SebastianBoldt/Jelly
# UserDefaults
pod 'DefaultsKit' # https://github.com/nmdias/DefaultsKit
# Code
pod 'SwiftLint' # https://github.com/realm/SwiftLint
# Resources
pod 'R.swift' # https://github.com/mac-cain13/R.swift
# Font
pod 'UIFontComplete' # https://github.com/Nirma/UIFontComplete
# Toast
pod 'Toast-Swift' # https://github.com/scalessec/Toast-Swift
# Placeholder
pod 'EmptyDataSet-Swift' # https://github.com/Xiaoye220/EmptyDataSet-Swift

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
