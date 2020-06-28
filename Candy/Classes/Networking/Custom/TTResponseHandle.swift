//
//  TTResponseHandle.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 用于今日头条返回数据结构
public protocol TTResponseHandle: CustomMoyaResponseable {}

public extension TTResponseHandle {

    var isHandleResult: Bool {
        true
    }

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(TTModel<String>.self)
        return res?.isSuccess ?? true
    }

    func customMoyaResultFailure(response: Response) -> Result<Response, MoyaError>? {
        guard
            let res = try? response.mapObject(TTModel<String>.self)
        else {
            return nil
        }
        // 自定义错误
        let customError = ErrorModel(message: res.message)
        // 放在 MoyaError.underlying 错误类型中返回
        return .failure(.underlying(customError, response))
    }
}
