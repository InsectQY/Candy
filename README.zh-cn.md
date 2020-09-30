# Candy

![Swift](https://img.shields.io/badge/Swift-5.3-orange.svg)

一个视频类的客户端，接口抓取自今日头条和阳光宽屏网。

## 要求

- Xcode 12 +
- Swift 5.3
- iOS 10.0 +

## 下载安装好依赖的版本

1. [点击下载](https://github.com/InsectQY/Candy/releases/download/0.1.0/Candy.zip)
2. 打开 "Candy.xcworkspace"
3. 运行程序

## 预览

![Screenshot1](https://ae01.alicdn.com/kf/HTB1cWjjbRKw3KVjSZTE5jcuRpXak.gif)

![Screenshot2](https://ae01.alicdn.com/kf/HTB1p.fdbR1D3KVjSZFy5jbuFpXaN.gif)

![Screenshot3](https://ae01.alicdn.com/kf/HTB1.6_bbL1H3KVjSZFB5jbSMXXaR.gif)

## 技术栈

- Clean architecture ([RxSwift](https://github.com/ReactiveX/RxSwift) + MVVM)
- 网络请求与缓存: 基于 Moya/RxSwift 的 [RxNetwork](<https://github.com/Pircate/RxNetwork>)
- 图片下载与缓存 ([Kingfisher](<https://github.com/onevcat/Kingfisher>)) 
- 视频播放 ([ZFPlayer](<https://github.com/renzifeng/ZFPlayer>))
- JSON 解析 ([CleanJSON](<https://github.com/Pircate/CleanJSON>))
- 自定义转场动画 ([Hero](https://github.com/HeroTransitions/Hero), [Jelly](https://github.com/SebastianBoldt/Jelly))
- 资源文件管理 ([R.Swift](https://github.com/mac-cain13/R.swift), [UIFontComplete](https://github.com/Nirma/UIFontComplete))
- 代码风格 ([SwiftLint](https://github.com/realm/SwiftLint))
- 路由 ([URLNavigator](<https://github.com/devxoul/URLNavigator>))
- 网络状态监测 ([RxReachability](https://github.com/RxSwiftCommunity/RxReachability))
- 第三方登录 ([MonkeyKing](https://github.com/nixzhu/MonkeyKing))
- UITableView/UICollectionView 空数据占位图 ([EmptyDataSet-Swift](https://github.com/Xiaoye220/EmptyDataSet-Swift))
- 指示器 ([Toast-Swift](https://github.com/scalessec/Toast-Swift), [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView))
- 键盘管理 ([IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager))
- 刷新控件 ([MJRefresh](<https://github.com/CoderMJLee/MJRefresh>))
- 全屏滑动返回 ([FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture))
- 搜索 ([PYSearch](https://github.com/ko1o/PYSearch))
- 分页视图 ([JXCategoryView](https://github.com/pujiaxin33/JXCategoryView))
## 编译和运行

如果你下载的是已经安装好依赖的版本，则跳过该步骤  

安装依赖

  ```ruby
  pod install
  ```

在 Xcode 中打开 workspace
  ```ruby
  open "Candy.xcworkspace"
  ```



