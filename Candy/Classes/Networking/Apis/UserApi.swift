//
//  UserApi.swift
//  Candy
//
//  Created by Insect on 2020/8/19.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

enum UserApi {

    /// 作者信息
    case profile(String)
    /// 相似作者推荐
    case similar
    /// 作者的所有视频
    case video(id: String, cursor: String)
}

extension UserApi: TargetType {
    var baseURL: URL {
        URL(string: Configs.Network.kuaiKanUrl)!
    }

    var path: String {
        switch self {
        case .profile:
            return "pearl-server/api/v1/user/profile2"
        case .similar:
            return "pearl-server/api/v1/user/similarUsers"
        case .video:
            return "pearl-server/api/v1/user/works"
        }
    }

    var task: Task {

        var parameters: [String: Any] = ["app": "pearl",
                                         "did": "04D90309-3DDF-4246-8747-5C761062793C"]
        switch self {
        case let .profile(id):
            parameters["tabType"] = 2
            parameters["id"] = id
        case .similar:
            break
        case let .video(id, cursor):
            parameters["did"] = id
            parameters["cursor"] = cursor
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
}

extension UserApi: KKResponseHandle {}
