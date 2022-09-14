//
//  UIApplicationExtension.swift
//  Candy
//
//  Created by Insect on 2021/9/13.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit

public extension UIApplication {

    static var keyWindow: UIWindow? {
        shared.windows.filter { $0.isKeyWindow }.first
    }

    static func delegate<T: UIApplicationDelegate>() -> T? {
        shared.delegate as? T
    }

    static var rootViewController: UIViewController? {
        getRootViewController(keyWindow?.rootViewController)
    }

    static func getRootViewController(_ inViewController: UIViewController?) -> UIViewController? {

        guard let inViewController else { return nil }

        if inViewController.isKind(of: UINavigationController.self) {
            return getRootViewController((inViewController as? UINavigationController)?.visibleViewController)
        } else if inViewController.isKind(of: UITabBarController.self) {
            return getRootViewController((inViewController as? UITabBarController)?.selectedViewController)
        } else {
            return inViewController
        }
    }
}
