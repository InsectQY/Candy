//
//  YGRespnseHandle.swift
//  Candy
//
//  Created by QY on 2020/1/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 用于阳光宽屏网返回数据结构
public protocol YGRespnseHandle: ResponseHandle {}

public extension YGRespnseHandle {

    var isHandle: Bool {
        true
    }

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(YGModel.self)
        return res?.isSuccess ?? true
    }

    func customMoyaResponse(response: Response) -> Result<Response, MoyaError>? {
        guard
            let res = try? response.mapObject(YGModel.self)
        else {
            return nil
        }
        // 自定义错误
        let customError = ErrorModel(message: res.base_resp.status_message)
        // 放在 Moya.objectMapping 错误类型中返回
        return Result<Moya.Response, MoyaError>
        .failure(.objectMapping(customError, response))
    }
}
