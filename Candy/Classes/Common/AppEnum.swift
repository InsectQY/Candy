//
//  AppEnum.swift
//  GamerSky
//
//  Created by QY on 2018/4/4.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation

enum ServerCode: String, Codable {

    /// 请求成功
    case success
}

/// 从哪里进入头条
enum TTFrom: String {

    case refresh = "refresh"
    case pull = "pull"
    case loadMore = "loadmore"
}
