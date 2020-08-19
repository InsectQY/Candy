//
//  KKModel.swift
//  Candy
//
//  Created by Insect on 2020/8/19.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

public struct KKModel<T: Codable>: Codable {
    /// 状态 code
    let status: Int
    /// 信息
    let message: String
    /// 数据
    let data: T

    /// 是否返回成功
    var isSuccess: Bool {
        message == "success"
    }
}
