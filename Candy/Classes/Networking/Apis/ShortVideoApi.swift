//
//  ShortVideoApi.swift
//  Candy
//
//  Created by Insect on 2020/8/18.
//  Copyright © 2020 Insect. All rights reserved.
//  swiftlint:disable force_unwrapping
//

import Moya

enum ShortVideoApi {
    /// 视频列表
    case list
    /// 评论
    case comment(id: String, cursor: String)
}

extension ShortVideoApi: TargetType {

    var method: Moya.Method {
        .get
    }

    var baseURL: URL {
        URL(string: Configs.Network.kuaiKanUrl)!
    }

    var path: String {
        switch self {
        case .list:
            return "pearl-server/api/v1/feeds"
        case .comment:
            return "comment-server/api/v1/comments"
        }
    }

    var task: Task {
        var parameters: [String: Any] = ["app": "pearl"]
        switch self {
        case .list:
            parameters["tabId"] = 3
            parameters["cid"] = 45101
        case let .comment(id, cursor):
            parameters["itemId"] = id
            parameters["cursor"] = cursor
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var validationType: ValidationType {
        .successCodes
    }

    var headers: [String: String]? {
        nil
    }
}

extension ShortVideoApi: KKResultValidate {}
