//
//  ResponseVerify.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 只用于处理 HTTP 状态码里成功的数据
public protocol ResponseHandle {

    /// 当 HTTP 状态码正确时，是否继续处理 (默认 false，不继续处理)
    var isHandle: Bool { get }
    /// 服务端返回的数据是否符合成功约定 (默认 true，全都符合)
    func isServerSuccess(response: Moya.Response) -> Bool
    /// 自定义返回的数据 (默认 nil，不自定义)
    func customMoyaResponse(response: Moya.Response) -> Result<Moya.Response, MoyaError>?
}

public extension ResponseHandle {

    var isHandle: Bool {
        false
    }

    func isServerSuccess(response: Moya.Response) -> Bool {
        true
    }

    func customMoyaResponse(response: Moya.Response) -> Result<Moya.Response, MoyaError>? {
        nil
    }
}

extension Moya.MultiTarget: ResponseHandle {}
