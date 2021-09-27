//
//  EmptyDataSet.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

struct EmptyDataSet {
    /// 数据源 nil 时显示的标题，默认 " "
    var title: String = ""
    /// 数据源 nil 时显示的描述，默认 " "
    var description: String = ""
    /// 数据源 nil 时显示的图片
    var image: UIImage?
    /// 数据源 nil 时是否可以滚动，默认 true
    var isShouldAllowScroll: Bool = false
    /// 垂直方向偏移量
    var verticalOffset: CGFloat = 0
    /// 点击了 View
    var didTapView: (() -> Void)?
}
