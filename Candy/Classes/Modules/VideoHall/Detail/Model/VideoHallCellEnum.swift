//
//  VideoHallCellEnum.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

/// cell 类型
enum VideoHallCellType {

    /// 标题
    case title(VideoHallDetailModel)
    /// 简介
    case intro(VideoHallDetailModel)
    /// 影人
    case role(VideoHallDetailModel)
    /// 集数
    case episode(VideoHallDetailModel)
}
