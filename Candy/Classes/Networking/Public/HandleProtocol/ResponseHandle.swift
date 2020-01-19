//
//  ResponseVerify.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 处理 Moya 返回的 Result<Moya.Response, MoyaError> 类型数据
public protocol ResponseHandle {

    /// 是否自定义处理 Result
    /// (默认 false，不继续处理)
    var isHandle: Bool { get }
    /// 适用于 HTTP code 成功的数据，判断服务端返回的数据是否符合成功约定
    /// @example: message == "success" , code == 0 ...
    ///  (默认 true，全都符合)
    func isServerSuccess(response: Moya.Response) -> Bool
    /// 自定义 Moya 返回数据
    ///  (默认 nil，不自定义)
    func customMoyaResult(response: Moya.Response) -> Result<Moya.Response, MoyaError>?
}

public extension ResponseHandle {

    var isHandle: Bool {
        false
    }

    func isServerSuccess(response: Moya.Response) -> Bool {
        true
    }

    func customMoyaResult(response: Moya.Response) -> Result<Moya.Response, MoyaError>? {
        nil
    }
}

extension Moya.MultiTarget: ResponseHandle {}
