//
//  ErrorPlugin.swift
//  SSDispatch
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya
import CleanJSON

/// 自定义插件
struct ErrorPlugin: PluginType {

//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//
//        var request = request
//        request.timeoutInterval = 5
//        return request
//    }

    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        var result = result

        /// 对 Http 状态码成功的数据再进行一次处理
        guard case let Result.success(response) = result else { return result }

        /// 阳光宽频网/微信登录的数据结构不适用
        if
            target.baseURL.absoluteString == Configs.Network.yangGuangUrl ||
            target.path == VideoHallApi.search(0, "").path ||
            target.baseURL.absoluteString == Configs.Network.weChatUrl { return result
        }

        guard
            let res = try? CleanJSONDecoder().decode(Model<String>.self, from: response.data)
        else {
            return result
        }

        if !res.isSuccess {
            // 自定义错误
            let customError = ErrorModel(message: res.message.rawValue)
            // 放在 Moya.objectMapping 错误类型中返回
            result = Result<Moya.Response, MoyaError>
            .failure(.objectMapping(customError, response))
        }

        return result
    }
}
