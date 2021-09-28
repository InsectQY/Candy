//
//  EmptyDataSet.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit

public struct EmptyDataSet {
    /// 标题
    var title: String?
    /// 描述
    var description: String?
    /// 图片颜色
    var imageTintColor: UIColor?
    /// 图片动画
    var imageAnimation: CAAnimation?
    /// 背景色
    var backgroundColor: UIColor?
    /// 图片
    var image: UIImage?
    /// 自定义 view
    var customView: UIView?
    /// 垂直方向偏移量
    var verticalOffset: CGFloat = 0

    /// 是否可以滚动
    var isShouldAllowScroll: Bool = false
    /// 是否允许点击
    var isShouldAllowTouch: Bool = true
    /// 点击了 View
    var didTapView: (() -> Void)?
    /// 点击了 button
    var didTapButton: (() -> Void)?
    /// 视图将要显示
    var willAppear: (() -> Void)?
    /// 已经显示
    var didAppear: (() -> Void)?
    /// 将要消失
    var willDisappear: (() -> Void)?
    /// 已经消失
    var didDisappear : (() -> Void)?
}
