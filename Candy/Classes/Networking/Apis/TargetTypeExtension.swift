//
//  BaseApi.swift
//  Candy
//
//  Created by QY on 2020/1/14.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya

/// 为 Moya TargetType 添加默认实现
extension TargetType {

    var method: Moya.Method {
        .get
    }

    var headers: [String: String]? {
        nil
    }

    var sampleData: Data {
        "".data(using: String.Encoding.utf8)!
    }

    var validationType: ValidationType {
        .successCodes
    }
}

public protocol ResponseVerify {

    func verifySuccess(response: Moya.Response) -> Bool
}

public extension ResponseVerify {

    func isSuccess(response: Moya.Response) -> Bool {
        true
    }
}

public extension TargetType where Self: ResponseVerify {

    func isSuccess(response: Moya.Response) -> Bool {
        verifySuccess(response: response)
    }
}
