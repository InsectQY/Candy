//
//  ParameterManger.swift
//  QYNews
//
//  Created by Insect on 2019/2/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

/// 为了在您运行 App 时保护您的隐私信息，该类中大部分数据采用写死的方式。
/// 这些参数大部分不是必传的，实际项目中可自行更改。

/// 从哪里进入头条
enum TTFrom: String {

    case refresh = "refresh"
    case pull = "pull"
    case loadMore = "loadmore"
}

class ParameterManger {

    static let shared = ParameterManger()

    /// 今日头条公共参数
    var TTParameter: [String: Any] {
        ["version_code": versionCode,
        "tma_jssdk_version": tmaJsSdkVersion,
        "app_name": appName,
        "vid": vid,
        "device_id": TTDeviceID,
        "channel": channel,
        "resolution": resolution,
        "aid": TTaid,
        "ab_feature": abFeature,
        "ab_version": abVersion,
        "ab_group": abGroup,
        "openudid": openudid,
        "cdid": cdid,
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
        "LBS_status": LBSStatus,
        "count": count]
    }

    /// 阳光宽屏网公共参数
    func YGParameter() -> [String: Any] {
        ["device_platform": YGDevicePlatform,
        "aid": YGaid,
        "device_id": YGDeviceID]
    }

    var count: Int {
        20
    }

    var cdid: String {
        "D2C0352E-C40C-450F-A1A6-CD22DDC2613A"
    }

    var abVersion: String {
        "668779,1251924,662099,1352822,668774,1197637,1367345,765194,857804,1358435,660830,1374021,1054755,1230781,1362836,1243993,662176,801968,707372,668775,1370513,1375658,1190524,1157750,1377185"
    }

    var LBSStatus: String {
        "authroize"
    }

    var abGroup: String {
        "794526"
    }

    var tmaJsSdkVersion: String {
        "1.42.1.2"
    }

    var osVersion: String {
        "13.2.3"
    }

    var versionCode: String {
        "7.5.2"
    }

    var appName: String {
        "news_article"
    }

    var vid: String {
        "375B45B8-89BB-43F9-80B3-CA5E7FCE030F"
    }

    var TTDeviceID: String {
        "68072144174"
    }

    var channel: String {
        "App Store"
    }

    var TTaid: String {
        "13"
    }

    var abFeature: String {
        "794526"
    }

    var ac: String {
        "WIFI"
    }

    var ssmix: String {
        "a"
    }

    var TTDevicePlatform: String {
        "iphone"
    }

    var deviceType: String {
        "iPhone XS Max"
    }

    var idfa: String {
        "00000000-0000-0000-0000-000000000000"
    }

    var openudid: String {
        "6f2330f741cbf07f42ca5bac8549d30f1292426a"
    }

    var resolution: String {
        "1242*2688"
    }

    var updateVersionCode: String {
        "75213"
    }

    var idfv: String {
        "375B45B8-89BB-43F9-80B3-CA5E7FCE030F"
    }

    var iid: String {
        "95923105939"
    }

    var abClient: String {
        "a1,f2,f7,e1"
    }

    var city: String {
        "北京"
    }

    var YGaid: String {
        "1364"
    }

    var YGDevicePlatform: String {
        "pc"
    }

    var YGDeviceID: String {
        "6628347419128202755"
    }
}
