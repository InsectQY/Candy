//
//  KKResponseHandle.swift
//  Candy
//
//  Created by Insect on 2020/8/19.
//  Copyright © 2020 Insect. All rights reserved.
//

import Moya
import MoyaResultValidate

/// 用于快看视频返回数据结构
public protocol KKResultValidate: MoyaResultValidateable {}

public extension KKResultValidate {

    func isServerSuccess(response: Response) -> Bool {
        let res = try? response.mapObject(KKModel<String>.self)
        return res?.isSuccess ?? true
    }
}
