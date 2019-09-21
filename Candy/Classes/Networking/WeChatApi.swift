//
//  WeChatApi.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//  swiftlint:disable force_unwrapping

import Moya
import MonkeyKing

enum WeChatApi {

    case userInfo(token: String, openid: String)
}

extension WeChatApi: TargetType {

    var baseURL: URL {
        URL(string: Configs.Network.weChatUrl)!
    }

    var path: String {
        "sns/userinfo"
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        "".data(using: String.Encoding.utf8)!
    }

    var task: Task {

        switch self {
        case let .userInfo(token, openid):
            return .requestParameters(parameters: ["access_token": token,
                                                   "openid": openid], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        nil
    }
}

extension WeChatApi {

    public static func login() -> Observable<(token: String, openID: String)> {

        return Observable<(token: String, openID: String)>.create { observer -> Disposable in

            MonkeyKing.oauth(for: .weChat) { oauthInfo, response, error in

                guard
                    let token = oauthInfo?["access_token"] as? String,
                    let openid = oauthInfo?["openid"] as? String
                else {
                    observer.onError(error!)
                    return
                }
                observer.onNext((token: token, openID: openid))
            }
            return Disposables.create()
        }
    }
}
