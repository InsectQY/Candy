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

    var moya: MoyaError? {
        self as? MoyaError
    }

    var errorModel: ErrorModel? {

        guard let moyaError = moya else { return nil }
        switch moyaError {
        case let .underlying(error, _):
            return error as? ErrorModel
        default:
            return nil
        }
    }
}

/// 封装 MoyaError，方便获取自定义的错误信息
/// 当你想获取原始数据时，Moya 原生提供了 var response: Moya.Response?
public extension MoyaError {

    /// Moya 返回的错误信息
    var responseDescription: String? {
        switch self {
        case let .underlying(error, _):
            return error.errorModel?.errorDescription
        default:
            return errorDescription
        }
    }
}
