//
//  ResponseVerify.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 处理 Moya 返回的 Result<Moya.Response, MoyaError> 类型数据
/// 有些服务端会自定义通用返回格式，例如:  "{code: xx, message: xx, data: xx}"
/// 这样的场景下前端需要在 Result.success 中对数据再做一次判断，造成代码冗余
/// 核心思想: 让所有  HTTP Status Code != 'success' 或  服务端返回的数据不符合成功约定，都返回自定义 Moya Result.failure 数据。此时 Result.success 永远返回过滤以后的成功数据，前端只需要在 Result.failure 中处理失败逻辑即可
/// 特性: 支持对每个接口设置独立判断规则
public protocol CustomMoyaResponseable {

    /// 当 HTTP Status Code == 'success'，判断服务端返回的数据是否符合成功约定
    /// 默认 true，全都符合，当 false 时，返回结果为 Result.failure 类型
    func isServerSuccess(response: Moya.Response) -> Bool
    /// 默认 nil，不自定义，返回 Result<Moya.Response, MoyaError>.failure(.underlying(response)) 类型数据
    func customMoyaFailureResult(response: Moya.Response) -> Result<Moya.Response, MoyaError>?
    /// 是否需要在 isServerSuccess = false && customMoyaFailureResult = nil 时，返回默认错误
    /// 默认 true，都返回默认错误
    func isReturnDefaultWhenCustomResultNil() -> Bool
}

public extension CustomMoyaResponseable {

    func isServerSuccess(response: Moya.Response) -> Bool {
        true
    }

    func customMoyaFailureResult(response: Moya.Response) -> Result<Moya.Response, MoyaError>? {
        nil
    }

    func isReturnDefaultWhenCustomResultNil() -> Bool {
        true
    }
}

public typealias TargetTypePlus = CustomMoyaResponseable & TargetType
