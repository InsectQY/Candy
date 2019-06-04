//
//  UIFontExtension.swift
//  Candy
//
//  Created by Insect on 2019/5/23.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import UIFontComplete

public extension UIFont {

    // swiftlint:disable force_unwrapping
    static func pingFangSCMedium(_ size: CGFloat) -> UIFont {
        return UIFont(font: .pingFangSCMedium, size: size)!
    }

    // swiftlint:disable force_unwrapping
    static func pingFangSCRegular(_ size: CGFloat) -> UIFont {
        return UIFont(font: .pingFangSCRegular, size: size)!
    }
}
