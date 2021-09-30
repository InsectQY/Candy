
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'

target 'Candy' do

use_modular_headers!
#use_frameworks!
inhibit_all_warnings!

 # OC
 # https://github.com/forkingdog/FDFullscreenPopGesture
pod 'FDFullscreenPopGesture'
# https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
pod 'UITableView+FDTemplateLayoutCell'
# page
# https://github.com/pujiaxin33/JXCategoryView
pod 'JXCategoryView'
# Video Player
# https://github.com/renzifeng/ZFPlayer
pod 'ZFPlayer'
pod 'ZFPlayer/ijkplayer'
pod 'ZFPlayer/ControlView'
# Search
# https://github.com/ko1o/PYSearch
pod 'PYSearch'
# Refresh
# https://github.com/CoderMJLee/MJRefresh
pod 'MJRefresh'

 # Swift

# RxSwift
# https://github.com/Pircate/RxNetwork
pod 'RxNetwork'
# https://github.com/Pircate/RxNetwork
pod 'RxNetwork/Cacheable'
# https://github.com/InsectQY/RxActivityIndicator
pod 'RxActivityIndicator'
# https://github.com/RxSwiftCommunity/NSObject-Rx
pod 'NSObject+Rx'
# https://github.com/RxSwiftCommunity/RxDataSources
pod 'RxDataSources'
# https://github.com/InsectQY/RxURLNavigator
pod 'RxURLNavigator'
# https://github.com/RxSwiftCommunity/RxOptional
pod 'RxOptional'
# https://github.com/srv7/RxMJ
pod 'RxMJ'
# https://github.com/RxSwiftCommunity/RxReachability
pod 'RxReachability'

# UIImage Download
# https://github.com/onevcat/Kingfisher
pod 'Kingfisher'
# https://github.com/Yeatse/KingfisherWebP
pod "KingfisherWebP"
# Codable
# https://github.com/Pircate/CleanJSON
pod 'CleanJSON'
# Keyboard
# https://github.com/hackiftekhar/IQKeyboardManager
pod 'IQKeyboardManagerSwift'
# HUD
# https://github.com/ninjaprox/NVActivityIndicatorView
pod 'NVActivityIndicatorView/Extended'
# Transitions
# https://github.com/HeroTransitions/Hero
pod 'Hero'
# https://github.com/SebastianBoldt/Jelly
pod 'Jelly'
# UserDefaults
# https://github.com/nmdias/DefaultsKit
pod 'DefaultsKit'
# Code
# https://github.com/realm/SwiftLint
pod 'SwiftLint'
# Resources
# https://github.com/mac-cain13/R.swift
pod 'R.swift'
# Font
# https://github.com/Nirma/UIFontComplete
pod 'UIFontComplete'
# Toast
# https://github.com/scalessec/Toast-Swift
pod 'Toast-Swift'
# Placeholder
# https://github.com/InsectQY/EmptyDataSetExtension
pod 'EmptyDataSetExtension/RxSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
