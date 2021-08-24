//
//  MoyaErrorExtension.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 将 Error protocol 转换为具体类型
public extension Error {

    var asMoyaError: MoyaError? {
        self as? MoyaError
    }

    var asErrorModel: ErrorModel? {
        self as? ErrorModel
    }
}

/// 封装 MoyaError，方便获取自定义的错误信息
/// 当你想获取原始数据时，Moya 原生提供了 var response: Moya.Response?
public extension MoyaError {

    /// Moya 返回的错误信息
    var responseErrorDescription: String? {
        switch self {
        case let .underlying(error, _):
            if let customErrorDescription = error.asErrorModel?.errorDescription {
                return customErrorDescription
            }
            return errorDescription
        default:
            return errorDescription
        }
    }
}
