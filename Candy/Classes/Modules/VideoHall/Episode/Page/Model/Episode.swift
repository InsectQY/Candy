//
//  Episode.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

class EpisodePage: Codable {
    /// 集数开始位置
    let start: Int
    /// 集数结束位置
    let end: Int

    init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }
}

/// 每页的集数信息
class TitleEpisodePage: EpisodePage {

    /// 标题
    var title: String = ""

    init(start: Int, end: Int, title: String) {
        self.title = title
        super.init(start: start, end: end)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
