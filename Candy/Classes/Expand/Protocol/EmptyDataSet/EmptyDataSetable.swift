//
//  EmptyDataSetable.swift
//  Candy
//
//  Created by Insect on 2020/6/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

public protocol EmptyDataSetable {

    /// 数据源 nil 时显示的标题，默认 " "
    var emptyDataSetTitle: String { get }
    /// 数据源 nil 时显示的描述，默认 " "
    var emptyDataSetDescription: String { get }
    /// 数据源 nil 时显示的图片
    var emptyDataSetImage: UIImage? { get }
    /// 没有网络时显示的标题
    var noConnectionTitle: String { get }
    /// 没有网络时显示的描述
    var noConnectionDescription: String { get }
    /// 没有网络时显示的图片
    var noConnectionImage: UIImage? { get }
    /// 数据源 nil 时是否可以滚动，默认 true
    var isEmptyDataSetShouldAllowScroll: Bool { get }
    /// 没有网络时是否可以滚动， 默认 false
    var isNoConnectionShouldAllowScroll: Bool { get }
    /// 垂直方向偏移量
    var verticalOffset: CGFloat { get }
}

public extension EmptyDataSetable {

    var emptyDataSetTitle: String {
        ""
    }

    var emptyDataSetDescription: String {
        ""
    }

    var emptyDataSetImage: UIImage? {
        nil
    }
    var noConnectionTitle: String {
        ""
    }

    var noConnectionDescription: String {
        ""
    }

    var noConnectionImage: UIImage? {
        nil
    }

    var isEmptyDataSetShouldAllowScroll: Bool {
        false
    }

    var isNoConnectionShouldAllowScroll: Bool {
        false
    }

    var verticalOffset: CGFloat {
        0
    }
}
