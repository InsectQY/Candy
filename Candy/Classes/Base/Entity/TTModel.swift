//
//  BaseModel.swift
//  GamerSky
//
//  Created by QY on 2018/4/2.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation

public struct TTModel<T: Codable>: Codable {

    /// 返回 "success" 为成功
    let message: String
    /// 是否有更多数据
    let has_more: Bool
    /// 加载更多时用到
    let offset: Int
    /// 数据
    let data: T

    /// 是否返回成功
    var isSuccess: Bool {
        message == "success"
    }
}
