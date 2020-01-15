//
//  ErrorPlugin.swift
//  SSDispatch
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya

/// 自定义错误插件
/// @required: 同时实现 Moya TargetType && ResponseHandle 两个 protocol
public struct CustomErrorPlugin: PluginType {

    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        var result = result

        guard
            // 只适用于 MultiTarget
            let target = target as? Moya.MultiTarget,
            // 是否需要对 HTTP 状态码成功的数据再进行一次处理
            target.isHandle,
            case let Result.success(response) = result,
            // 服务端返回的数据是否符合成功约定
            !target.isServerSuccess(response: response),
            // 自定义的返回结果
            let customResponse = target.customMoyaResponse(response: response)
        else {
            return result
        }
        result = customResponse

        return result
    }
}
