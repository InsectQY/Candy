//
//  KKResponseHandle.swift
//  Candy
//
//  Created by Insect on 2020/8/19.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 用于快看视频返回数据结构
public protocol KKResponseHandle: CustomMoyaResponseable {}

public extension KKResponseHandle {

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(KKModel<String>.self)
        return res?.isSuccess ?? true
    }

    func customMoyaFailureResult(response: Response) -> Result<Response, MoyaError>? {
        guard
            let res = try? response.mapObject(KKModel<String>.self)
        else {
            return nil
        }
        // 自定义错误
        let customError = ErrorModel(message: res.message)
        // 放在 MoyaError.underlying 错误类型中返回
        return .failure(.underlying(customError, response))
    }
}
