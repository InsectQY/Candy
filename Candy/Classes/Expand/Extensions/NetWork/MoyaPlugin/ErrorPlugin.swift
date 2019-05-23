//
//  ErrorPlugin.swift
//  SSDispatch
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya
import Result
import CleanJSON

/// 自定义插件
struct ErrorPlugin: PluginType {

    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        var result = result

        // 判断是否成功
        if (try? result.value?.filterSuccessfulStatusCodes()) == nil {

            let error: MoyaError = result.error ?? .underlying(LightError(code: 0, message: "抱歉~好像出错了哟~"), result.value)
            return Result<Moya.Response, MoyaError>(error: error)
        }

        switch result {

        case let .success(response):

            /// 阳光宽频网/微信登录的数据结构不适用
            if
                target.baseURL.absoluteString == Configs.Network.yangGuangUrl ||
                target.path == "video/openapi/v1/" ||
                target.baseURL.absoluteString == Configs.Network.weChatUrl { break
            }

            guard
                let res = try? CleanJSONDecoder().decode(Model<String>.self, from: response.data)
            else {
                return result
            }

            if res.message != .success {

                result = Result<Moya.Response, MoyaError>(error: MoyaError.objectMapping(LightError(code: 0, message: res.message.rawValue), response))
            }
        case let .failure(error):
            result = Result<Moya.Response, MoyaError>(error: error)
        }

        return result
    }
}
