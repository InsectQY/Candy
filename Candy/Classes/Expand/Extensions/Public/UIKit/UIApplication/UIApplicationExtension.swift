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

        var rootViewController: UIViewController? = inViewController

        while inViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }

        guard let rootVc = rootViewController else { return nil }

        if rootVc.isKind(of: UINavigationController.self) {
            return getRootViewController((rootVc as? UINavigationController)?.visibleViewController)
        } else if rootVc.isKind(of: UITabBarController.self) {
            return getRootViewController((rootVc as? UITabBarController)?.selectedViewController)
        } else {
            return rootVc
        }
    }
}
