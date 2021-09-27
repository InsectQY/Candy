//
//  ErrorPlugin.swift
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya

/// Moya 自定义返回结果插件，处理 Result<Moya.Response, MoyaError> 类型的返回结果
/// 必须实现 TargetType & CustomMoyaResultable 两个 protocol
public struct CustomResultPlugin: PluginType {
    public func process(_ result: Result<Moya.Response, MoyaError>,
                        target: TargetType) -> Result<Moya.Response, MoyaError> {
        guard
            let target = asTargetTypePlus(target)
        else {
            return result
        }

        switch result {
        case let .success(response):

            // 服务端返回的数据是否符合成功约定
            if target.isServerSuccess(response: response) {
                return result
            }
            // 不符合成功约定，是否自定义返回结果
            if let customResult = target.customMoyaResult(response: response) {
                return customResult
            }
            // 返回默认错误
            return .failure(.underlying(UnderlyingError(), response))
        case .failure:
            return result
        }
    }

    private func asTargetTypePlus(_ target: TargetType) -> CustomMoyaResultable? {
        if let multiTarget = target as? Moya.MultiTarget { // 如果是 MultiTarget，则取出真实的 TargetType
            return multiTarget.target as? CustomMoyaResultable
        }
        return target as? CustomMoyaResultable
    }
}

public struct UnderlyingError: LocalizedError {
    public var errorDescription: String? {
        "response content is not comply with the convention"
    }
}
