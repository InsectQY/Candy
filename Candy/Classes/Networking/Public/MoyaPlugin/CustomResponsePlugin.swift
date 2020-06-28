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
/// 必须实现 TargetType & CustomMoyaResponseable 两个 protocol
public struct CustomResponsePlugin: PluginType {

    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        guard
            let target = getPlus(target),
            // 是否对 Result 数据再进行一次处理
            target.isHandleResult
        else {
            return result
        }

        switch result {
        case let .success(response):
            guard
                // 服务端返回的数据是否符合成功约定
                !target.isServerSuccess(response: response),
                // 如果 nil 则 没有自定义返回结果
                let customResponse = target.customMoyaResultFailure(response: response)
            else {
                return result
            }
            // isServerSuccess == false && 自定义了返回失败
            return customResponse
        case let .failure(error):
            guard
                // 如果 nil 则 error 类型一定是 .underlying(Swift.Error, Response?)
                let response = error.moya?.response,
                // 如果 nil 则 没有自定义返回结果
                let customResponse = target.customMoyaResultFailure(response: response)
            else {
                return result
            }
            // 自定义了返回结果
            return customResponse
        }
    }

    private func getPlus(_ target: TargetType) -> TargetTypePlus? {
        if let multiTarget = target as? Moya.MultiTarget { // 如果是 MultiTarget，则取出真实的 TargetType
            return multiTarget.target as? TargetTypePlus
        }
        return target as? TargetTypePlus
    }
}
