//
//  ErrorPlugin.swift
//  SSDispatch
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya

/// Moya 自定义返回结果插件，处理 Result<Moya.Response, MoyaError> 类型的返回结果
/// @required: 同时实现 Moya TargetType && ResponseHandle 两个 protocol
public struct CustomResponsePlugin: PluginType {

    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        guard
            // 只适用于 MultiTarget
            let target = target as? Moya.MultiTarget,
            // 是否对 Result 数据再进行一次处理
            target.isHandle
        else {
            return result
        }

        switch result {
        case let .success(response):
            // 服务端返回的数据是否符合成功约定
            if target.isServerSuccess(response: response) {
                return result
            }
            return customResult(target: target, response: response)
        case let .failure(error):
            guard
                let response = error.moya?.response
            else {
                return result
            }
            return customResult(target: target, response: response)
        }
    }

    private func customResult(target: MultiTarget, response: Response) -> Result<Moya.Response, MoyaError> {
        if let customResponse = target.customMoyaResult(response: response) {
            // 自定义了返回结果
            return customResponse
        } else {
            // customMoyaResponse == nil 默认返回 Moya.jsonMapping 错误
            return Result<Moya.Response, MoyaError>
            .failure(.jsonMapping(response))
        }
    }
}
