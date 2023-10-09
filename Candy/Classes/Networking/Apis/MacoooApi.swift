//
//  MacoooApi.swift
//  Candy
//
//  Created by insect on 2023/10/7.
//  Copyright © 2023 Insect. All rights reserved.
//

import Moya

enum MacoooApi {
    case category
    case list(code: String, page: Int)
    case comment(String)
}

extension MacoooApi: TargetType {
    var baseURL: URL {
        URL(string: Configs.Network.macoooUrl)!
    }

    var path: String {
        switch self {
        case .category:
            return "/hello/v232"
        case let .list(code, _):
            return "/c/\(code)/3"
        case let .comment(code):
            return "/cmt/m/\(code)"
        }
    }

    var method: Moya.Method {

        switch self {
        case .category:
            return .post
        case .list:
            return .get
        case .comment:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case .category:
            return .requestParameters(parameters: ["deviceId": "09DDC45C-6E7D-49BA-A133-C8D13FC5FF49"],
                                      encoding: JSONEncoding.default)
        case let .list(_, page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case .comment:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        ["Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyY29kZSI6IkFOT1lfWHFQR0JZZWI3WDB6IiwiZGV2aWNlSWQiOiIwOUREQzQ1Qy02RTdELTQ5QkEtQTEzMy1DOEQxM0ZDNUZGNDkiLCJpYXQiOjE2NjY1OTU0MzUsImV4cCI6MTY5NzM1MzgzNX0.RJ6YJa4gjygNkmqAmSm2ml5-UnvCZWvyEm4-V6Y6vyA",
         "Version": "2.5.6",
         "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Html5Plus/1.0"]
    }

    var validationType: ValidationType {
        .successCodes
    }
}
