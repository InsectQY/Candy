//
//  ParameterManger.swift
//  QYNews
//
//  Created by Insect on 2019/2/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

/// 为了在您运行 App 时保护您的隐私信息，该类中大部分数据采用写死的方式。这些参数大部分不是必传的，实际项目中可自行更改。

class ParameterManger {

    static let shared = ParameterManger()

    /// 今日头条公共参数
    var TTParameter: [String: Any] {
        return ["version_code": versionCode,
                "tma_jssdk_version": tmaJsSdkVersion,
                "app_name": appName,
                "vid": vid,
                "device_id": TTDeviceID,
                "channel": channel,
                "resolution": resolution,
                "aid": TTaid,
                "ab_feature": abFeature,
                "update_version_code": updateVersionCode,
                "idfv": idfv,
                "ac": ac,
                "os_version": osVersion,
                "ssmix": ssmix,
                "device_platform": TTDevicePlatform,
                "iid": iid,
                "ab_client": abClient,
                "device_type": deviceType,
                "idfa": idfa,
                "city": city,
                "openudid": openudid]
    }

    /// 阳光宽屏网公共参数
    func YGParameter() -> [String: Any] {
        return ["device_platform": YGDevicePlatform,
                "aid": YGaid,
                "device_id": YGDeviceID]
    }

    var tmaJsSdkVersion: String {
        return "1.10.6.4"
    }

    var osVersion: String {
        return "12.1.5"
    }

    var versionCode: String {
        return "7.0.9"
    }

    var appName: String {
        return "news_article"
    }

    var vid: String {
        return "6095FCC3-881F-4DB9-8135-88945F9D7E37"
    }

    var TTDeviceID: String {
        return "40453770071"
    }

    var channel: String {
        return "App Store"
    }

    var TTaid: String {
        return "13"
    }

    var abFeature: String {
        return "z1"
    }

    var ac: String {
        return "WIFI"
    }

    var ssmix: String {
        return "a"
    }

    var TTDevicePlatform: String {
        return "iphone"
    }

    var deviceType: String {
        return "iPhone 7 Plus"
    }

    var idfa: String {
        return "96A533E2-6493-4977-A134-3BA8C268875F"
    }

    var openudid: String {
        return "1a42c25d877e65b14bd273324aa776e819d4659e"
    }

    var resolution: String {
        return "1242*2208"
    }

    var updateVersionCode: String {
        return "70901"
    }

    var idfv: String {
        return "6095FCC3-881F-4DB9-8135-88945F9D7E37"
    }

    var iid: String {
        return "59995201761"
    }

    var abClient: String {
        return "a1,f2,f7,e1"
    }

    var city: String {
        return "北京"
    }

    var YGaid: String {
        return "1364"
    }

    var YGDevicePlatform: String {
        return "pc"
    }

    var YGDeviceID: String {
        return "6628347419128202755"
    }
}
