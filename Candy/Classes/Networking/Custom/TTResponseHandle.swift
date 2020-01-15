//
//  TTResponseHandle.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 用于今日头条返回数据结构
public protocol TTResponseHandle: ResponseHandle {}

public extension TTResponseHandle {

    var isHandle: Bool {
        true
    }

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(Model<String>.self)
        return res?.isSuccess ?? true
    }

    func customMoyaResponse(response: Response) -> Result<Response, MoyaError>? {
        guard
            let res = try? response.mapObject(Model<String>.self)
        else {
            return nil
        }
        // 自定义错误
        let customError = ErrorModel(message: res.message.rawValue)
        // 放在 Moya.objectMapping 错误类型中返回
        return Result<Moya.Response, MoyaError>
        .failure(.objectMapping(customError, response))
    }
}
