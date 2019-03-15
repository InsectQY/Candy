//
//  LabelExtension.swift
//  Demo
//
//  Created by insect_qy on 2018/7/18.
//  Copyright © 2018年 insect_qy. All rights reserved.
//

import UIKit

private var horizontalKey = 100
private var verticalKey = 200
private var fitFontSizeKey = 300

public extension UILabel {

    @IBInspectable var fitFontSize: CGFloat {

        set {

            font = UIFont(name: font.fontName, size: KScaleH(fitFontSize))
            objc_setAssociatedObject(self, &fitFontSizeKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {

            if let fitSize = objc_getAssociatedObject(self, &fitFontSizeKey) as? CGFloat {
                return fitSize
            }
            return font.pointSize
        }
    }
}

public extension NSLayoutConstraint {

    /// 水平方向约束
    @IBInspectable var verticalConstant: CGFloat {

        set {

            constant = KScaleV(verticalConstant)
            objc_setAssociatedObject(self, &verticalKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {

            if let vc = objc_getAssociatedObject(self, &verticalKey) as? CGFloat {
                return vc
            }
            return constant
        }
    }

    /// 竖直方向约束
    @IBInspectable var horizontalConstant: CGFloat {

        set {

            constant = KScaleH(horizontalConstant)
            objc_setAssociatedObject(self, &horizontalKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {

            if let horizontalConstant = objc_getAssociatedObject(self, &horizontalKey) as? CGFloat {
                return horizontalConstant
            }
            return constant
        }
    }
}
