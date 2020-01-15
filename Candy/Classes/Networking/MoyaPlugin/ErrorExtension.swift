//
//  MoyaErrorExtension.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

public extension Error {

    var moya: MoyaError? {
        self as? MoyaError
    }

    var errorModel: ErrorModel? {
        self as? ErrorModel
    }
}

/// MoyaError 的封装，方便直接取到自定义的错误信息
/// 当你想获取原始数据时，Moya 原生提供了 var response: Moya.Response?
public extension MoyaError {

    /// Moya 返回的错误信息
    var responseDescription: String? {
        switch self {
        case let .objectMapping(error, _):
            return error.errorModel?.message
        default:
            return errorDescription
        }
    }
}
