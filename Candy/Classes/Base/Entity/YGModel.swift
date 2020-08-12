//
//  YGModel.swift
//  Candy
//
//  Created by QY on 2020/1/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

public struct YGModel: Codable {
    let BaseResp: YGBaseRep

    /// 是否返回成功
    var isSuccess: Bool {
        BaseResp.StatusMessage == "success"
    }
}

public struct YGBaseRep: Codable {
    let StatusCode: Int
    let StatusMessage: String
}
