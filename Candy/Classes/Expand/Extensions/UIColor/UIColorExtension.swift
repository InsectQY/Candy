//
//  UIColorExtension.swift
//  Candy
//
//  Created by Insect on 2019/5/23.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public extension UIColor {

    static func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    static var nav: UIColor {
        .white
    }

    static var main: UIColor {
        .RGBA(255, 85, 85)
    }

    static var background: UIColor {
        .RGBA(245, 246, 247)
    }

    static var user: UIColor {
        .RGBA(50, 79, 131)
    }

    static var tabBarNormal: UIColor {
        .RGBA(138, 138, 138)
    }
}
