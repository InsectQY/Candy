//
//  YGModel.swift
//  Candy
//
//  Created by QY on 2020/1/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

public struct YGModel: Codable {
    let base_resp: YGBaseRep

    /// 是否返回成功
    var isSuccess: Bool {
        base_resp.status_message == "success"
    }
}

public struct YGBaseRep: Codable {
    let status_code: Int
    let status_message: String
}
