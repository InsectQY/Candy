//
//  ShortVideoApi.swift
//  Candy
//
//  Created by Insect on 2020/8/18.
//  Copyright © 2020 Insect. All rights reserved.
//  swiftlint:disable force_unwrapping
//

import Moya

import Foundation

enum ShortVideoApi {

    /// 视频列表
    case list
}

extension ShortVideoApi: TargetType {
    var baseURL: URL {
        URL(string: Configs.Network.kuaiKanUrl)!
    }

    var path: String {
        "pearl-server/api/v1/feeds"
    }

    var task: Task {
        return .requestParameters(parameters: ["tabId": 3,
                                               "cid": 45101,
                                               "app": "pearl"], encoding: URLEncoding.default)
    }
}
