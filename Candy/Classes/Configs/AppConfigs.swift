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

        static let touTiaoBaseUrl = "https://is.snssdk.com"
        static let videoParseUrl = "https://i.snssdk.com"
        static let yangGuangUrl = "http://365yg.com"
        static let weChatUrl = "https://api.weixin.qq.com"
    }

    struct Dimensions {

        static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    }

    struct Time {
        static let imageTransition: TimeInterval = 1.0
    }

    struct DictionaryKeys {

        static let seekTime = TypedUserInfoKey(key: "seekTime",
                                               type: TimeInterval.self)
        static let newsModel = TypedUserInfoKey(key: "news",
                                                type: NewsModel.self)
    }
}

enum Keys {

    case weChat

    var appID: String {
        switch self {
        case .weChat: return ""
        }
    }

    var appKey: String {
        switch self {
        case .weChat: return ""
        }
    }
}
