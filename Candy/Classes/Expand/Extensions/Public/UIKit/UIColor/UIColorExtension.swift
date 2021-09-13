//
//  UIColorExtension.swift
//  Candy
//
//  Created by Insect on 2019/5/23.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

public extension UIColor {

    static func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
