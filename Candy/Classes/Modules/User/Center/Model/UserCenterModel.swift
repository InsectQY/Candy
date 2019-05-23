//
//  UserCenterModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

enum UserCenterOperate: String, Codable {

    /// 收藏
    case collect
    /// 免责声明
    case statement
    /// 设置
    case setting
}

struct UserCenterModel: Codable {

    /// 图片
    let icon: String
    /// 名称
    let title: String
    /// 类型
    let type: UserCenterOperate
}
