//
//  ErrorPlugin.swift
//  SSDispatch
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya

/// Moya 自定义返回结果的插件，只处理 Result.success 类型的返回结果，Result.failure 暂不提供(没有必要就去掉了)
/// @required: 同时实现 Moya TargetType && ResponseHandle 两个 protocol
public struct CustomResponsePlugin: PluginType {

    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        var result = result

        guard
            // 只适用于 MultiTarget
            let target = target as? Moya.MultiTarget,
            // 是否对 HTTP 状态码成功的数据再进行一次处理
            target.isHandle,
            case let Result.success(response) = result,
            // 服务端返回的数据是否符合成功约定
            !target.isServerSuccess(response: response)
        else {
            return result
        }

        // 方法执行到这，说明 isHandle && isServerSuccess == false
        if let customResponse = target.customMoyaResponse(response: response) {
            // 自定义了返回结果
            result = customResponse
        } else {
            // customMoyaResponse == nil 默认返回 Moya.jsonMapping 错误
            result = Result<Moya.Response, MoyaError>
            .failure(.jsonMapping(response))
        }

        return result
    }
}
