//
//  Episode.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

/// 每页的集数信息
struct EpisodePage: Codable {

    /// 集数开始位置
    let start: Int
    /// 集数结束位置
    let end: Int
    /// 已经选择的集数位置
    var selIndex: Int

    /// 选中的集数是否在当前页面中
    var isInRange: Bool {
        (start...end).contains(selIndex)
    }
}
