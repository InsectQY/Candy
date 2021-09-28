//
//  AppConfig.swift
//  GamerSky
//
//  Created by QY on 2018/4/2.
//  Copyright © 2018年 QY. All rights reserved.
//

import UIKit

struct Configs {

    struct Network {

        /// 今日头条
        static let touTiaoBaseUrl = "https://api3-normal-c-hl.snssdk.com"
        static let videoParseUrl = "https://i.snssdk.com"
        /// 阳光宽频网
        static let yangGuangUrl = "https://365yg.com"
        /// 快看点
        static let kuaiKanUrl = "https://api.yuncheapp.cn"
    }

    struct Time {
        static let imageTransition: TimeInterval = 1.0
        /// 图片缓存时间 (1 周)
        static let maxImageCache: TimeInterval = 60 * 60 * 24 * 7
        /// 图片加载超时时间
        static let imageDownloadTimeout: TimeInterval = 15
        /// 网络请求超时时间
        static let netWorkTimeout: TimeInterval = 15
    }

    struct DictionaryKeys {

        static let seekTime = TypedUserInfoKey(key: "seekTime",
                                               type: TimeInterval.self)
        static let newsModel = TypedUserInfoKey(key: "news",
                                                type: NewsModel.self)
    }
}
