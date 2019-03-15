//
//  AppMacro.swift
//  SSDispatch
//
//  Created by insect_qy on 2018/7/27.
//  Copyright © 2018年 insect_qy. All rights reserved.

import UIKit

/// RGBA
public func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 水平方向缩放
public func KScaleH(_ c: CGFloat) -> CGFloat {
    return ScreenWidth / 414 * c
}

/// 垂直方向缩放
public func KScaleV(_ c: CGFloat) -> CGFloat {
    return ScreenHeight / 736 * c
}
