# Candy

![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg) [![中文文档](https://woolson.gitee.io/npmer-badge/-007ec6-%E4%B8%AD%E6%96%87%E6%96%87%E6%A1%A3-007ec6-github-ffffff-square-gradient-shadow.svg)](https://github.com/InsectQY/Candy/blob/master/README.zh-cn.md)

[中文文档](https://github.com/InsectQY/Candy/blob/master/README.zh-cn.md)

Video iOS client written in RxSwift and MVVM

## Requirements

- Xcode 11.5 +
- Swift 5.2
- iOS 10.0 +

## Download Release

1. [Download](https://github.com/InsectQY/Candy/releases/download/0.1.0/Candy.zip)
2. Open "Candy.xcworkspace"
3. Run

## Screenshots

![Screenshot1](https://ae01.alicdn.com/kf/HTB1cWjjbRKw3KVjSZTE5jcuRpXak.gif)

![Screenshot2](https://ae01.alicdn.com/kf/HTB1p.fdbR1D3KVjSZFy5jbuFpXaN.gif)

![Screenshot3](https://ae01.alicdn.com/kf/HTB1.6_bbL1H3KVjSZFB5jbSMXXaR.gif)

## Technologies

- Clean architecture ([RxSwift](https://github.com/ReactiveX/RxSwift) + MVVM)
- Network request and cache: based on Moya/RxSwift [RxNetwork](<https://github.com/Pircate/RxNetwork>)
- Download and cache images ([Kingfisher](<https://github.com/onevcat/Kingfisher>)) 
- Video player ([ZFPlayer](<https://github.com/renzifeng/ZFPlayer>))
- JSON decoder ([CleanJSON](<https://github.com/Pircate/CleanJSON>))
- Custom transition animations ([Hero](https://github.com/HeroTransitions/Hero), [Jelly](https://github.com/SebastianBoldt/Jelly))
- Resources manager ([R.Swift](https://github.com/mac-cain13/R.swift), [UIFontComplete](https://github.com/Nirma/UIFontComplete))
- Code style ([SwiftLint](https://github.com/realm/SwiftLint))
- Router ([URLNavigator](<https://github.com/devxoul/URLNavigator>))
- Monitor network status ([RxReachability](https://github.com/RxSwiftCommunity/RxReachability))
-  OAuth2 authentication ([MonkeyKing](https://github.com/nixzhu/MonkeyKing))
-  Show empty datasets whenever the UITableView/UICollectionView has no content to display ([EmptyDataSet-Swift](https://github.com/Xiaoye220/EmptyDataSet-Swift))
- HUD ([Toast-Swift](https://github.com/scalessec/Toast-Swift), [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView))
- Keyboard manager ([IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager))
- Refresh component ([MJRefresh](<https://github.com/CoderMJLee/MJRefresh>))
- Fullscreen pop gesture ([FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture))
- Search controller ([PYSearch](https://github.com/ko1o/PYSearch))
- Category view ([JXCategoryView](https://github.com/pujiaxin33/JXCategoryView))
## Building and Running

Skip this step if you are downloading an installed dependent version 

Install dependencies

  ```ruby
  pod install
  ```

Open the workspace in Xcode

  ```ruby
  open "Candy.xcworkspace"
  ```

