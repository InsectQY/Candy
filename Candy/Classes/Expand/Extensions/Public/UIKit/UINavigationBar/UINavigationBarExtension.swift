//
//  UINavigationBarExtension.swift
//  Scanking
//
//  Created by Scanking on 2021/09/15.
//  Copyright © 2021 Scanking. All rights reserved.
//

/// 不包含滚动内容的界面
/// - UINavigationBar UITabBar 的样式由 scrollEdgeAppearance 属性控制
/// - 当 scrollEdgeAppearance 为 nil 时，bar 将变透明

/// 包含滚动内容的界面
/// - 滚动的内容和 bar 没有重叠的时候，采用 scrollEdgeAppearance 属性控制
/// - 滚动的内容和 bar 有重叠的时候，采用 standardAppearance 属性控制

/// iOS 13 ，iOS 14
/// 默认 standardAppearance 为毛玻璃，
/// 默认 scrollEdgeAppearance 为毛玻璃，
/// 因此无论内容是否可以滚动，bar 都是毛玻璃。

/// iOS 15
/// 默认 standardAppearance 为毛玻璃，
/// 默认 scrollEdgeAppearance 为 nil。
/// 因此滚动的内容和 bar 没有重叠时 bar 将变透明，有重叠时变毛玻璃，
/// 没有滚动的内容将变透明。

/// Features:
/// ✅ 使所有系统的 UINavigationBar appearance 属性保持一致

import UIKit

public extension UINavigationBarWrapper where Base: UINavigationBar {

    /// Inline Title text attributes. If the font or color are unspecified, appropriate defaults are supplied.
    var titleTextAttributes: [NSAttributedString.Key : Any] {

        set {

            if #available(iOS 13.0, *) {

                standardAppearance.titleTextAttributes = newValue
                setUpAppearance()
            } else {
                base.titleTextAttributes = titleTextAttributes
            }
        }

        get {

            if #available(iOS 13.0, *) {
                return standardAppearance.titleTextAttributes
            } else {
                return base.titleTextAttributes ?? [:]
            }
        }
    }

    var titleTextForegroundColor: UIColor? {

        set {

            if let value = newValue {
                titleTextAttributes[.foregroundColor] = value
            }
        }

        get {
            titleTextAttributes[.foregroundColor] as? UIColor
        }
    }

    var titleTextFont: UIFont? {

        set {

            if let value = newValue {
                titleTextAttributes[.font] = value
            }
        }

        get {
            titleTextAttributes[.font] as? UIFont
        }
    }

    var backgroundColor: UIColor? {

        set {

            if #available(iOS 13.0, *) {

                standardAppearance.backgroundColor = newValue
                setUpAppearance()
            } else {
                base.barTintColor = backgroundColor
            }
        }

        get {

            if #available(iOS 13.0, *) {
                return standardAppearance.backgroundColor
            } else {
                return base.barTintColor
            }
        }
    }

    var backgroundImage: UIImage? {

        set {

            if #available(iOS 13.0, *) {

                standardAppearance.backgroundImage = newValue
                setUpAppearance()
            } else {
                base.setBackgroundImage(backgroundImage, for: .default)
            }
        }

        get {
            if #available(iOS 13.0, *) {
                return standardAppearance.backgroundImage
            } else {
                return base.backgroundImage(for: .default)
            }
        }
    }

    func setIsTransparent(_ isTransparent: Bool) {

        if #available(iOS 13.0, *) {

            if isTransparent {
                standardAppearance.configureWithTransparentBackground()
            } else {
                standardAppearance.configureWithDefaultBackground()
            }
            setUpAppearance()
        } else {

            let image: UIImage? = isTransparent ? UIImage() : nil
            base.setBackgroundImage(image,
                                    for: .default)
            base.shadowImage = image
        }
    }

     private func setUpAppearance() {
         if #available(iOS 13.0, *) {
             base.standardAppearance = standardAppearance
             base.scrollEdgeAppearance = standardAppearance
         }
    }

    @available(iOS 13.0, *)
    var standardAppearance: UINavigationBarAppearance {

        let isInit = base.standardAppearance.isKind(of: UINavigationBarAppearance.self)
        if isInit {
            return base.standardAppearance
        } else {
            return UINavigationBarAppearance()
        }
    }

    @available(iOS 13.0, *)
    var scrollEdgeAppearance: UINavigationBarAppearance? {
        base.scrollEdgeAppearance
    }
}
