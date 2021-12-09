//
//  TTResponseHandle.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya
import MoyaResultValidate

/// 用于今日头条返回数据结构
public protocol TTResultValidate: MoyaResultValidateable {}

public extension TTResultValidate {

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(TTModel<String>.self)
        return res?.isSuccess ?? true
    }
}
