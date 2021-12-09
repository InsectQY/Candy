//
//  YGResponseHandle.swift
//  Candy
//
//  Created by QY on 2020/1/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya
import MoyaResultValidate

/// 用于阳光宽屏网返回数据结构
public protocol YGResultValidate: MoyaResultValidateable {}

public extension YGResultValidate {

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(YGModel.self)
        return res?.isSuccess ?? true
    }
}
