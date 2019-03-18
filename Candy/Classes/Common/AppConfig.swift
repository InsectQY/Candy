//
//  AppConfig.swift
//  GamerSky
//
//  Created by QY on 2018/4/2.
//  Copyright © 2018年 QY. All rights reserved.
//

import UIKit

// MARK: - 全局公用属性
public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 网络加载图片动画时长
public let imageTransitionTime: TimeInterval = 1.0

/// 主机地址
public let TouTiaoHostIP = "https://is.snssdk.com"

public let VideoParseIP = "https://i.snssdk.com"

public let YangGuangIP = "http://365yg.com"

public let WeChatIP = "https://api.weixin.qq.com"

/// Dictionary Key
let seekTimeTypedKey = TypedUserInfoKey(key: "seekTime", type: TimeInterval.self)

let newsTypedKey = TypedUserInfoKey(key: "news", type: NewsModel.self)

let indexPathTypedKey = TypedUserInfoKey(key: "indexPath", type: IndexPath.self)

let categoryTypedKey = TypedUserInfoKey(key: "category", type: String.self)

let UGCVideoListTypedKey = TypedUserInfoKey(key: "items", type: [UGCVideoListModel].self)

extension UIFont {

    // swiftlint:disable force_unwrapping
    public static func PFM(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size)!
    }

    // swiftlint:disable force_unwrapping
    public static func PFR(_ size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size)!
    }
}

extension UIColor {

    public static var nav: UIColor {
        return .white
    }

    public static var main: UIColor {
        return RGBA(255, 85, 85)
    }

    public static var background: UIColor {
        return RGBA(245, 246, 247)
    }

    public static var user: UIColor {
        return RGBA(50, 79, 131)
    }
}

extension Notification {

    /// 列表滚动
    static var pageDidScroll: Notification.Name {
        return Notification.Name("pageDidScroll")
    }

    /// 选中了某一集
    static var clickEpisode: Notification.Name {
        return Notification.Name("clickEpisode")
    }
}
