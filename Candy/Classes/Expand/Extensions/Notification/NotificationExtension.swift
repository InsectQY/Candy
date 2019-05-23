//
//  NotificationExtension.swift
//  Candy
//
//  Created by apple on 2019/5/23.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public extension Notification {

    /// 列表滚动
    static var pageDidScroll: Notification.Name {
        return Notification.Name("pageDidScroll")
    }

    /// 选中了某一集
    static var clickEpisode: Notification.Name {
        return Notification.Name("clickEpisode")
    }

    /// 没有网络时, 点击了视频占位图
    static var videoNoConnectClick: Notification.Name {
        return Notification.Name("videoNoConnectClick")
    }

    /// 没有网络时, 点击了小视频占位图
    static var UGCVideoNoConnectClick: Notification.Name {
        return Notification.Name("videoUGCNoConnectClick")
    }
}
