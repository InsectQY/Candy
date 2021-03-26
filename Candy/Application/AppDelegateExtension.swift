//
//  AppDelegateExtension.swift
//  Assistant
//
//  Created by QY on 2021/3/21.
//

import Foundation

extension AppDelegate {

    static var shared: AppDelegate {
        // swiftlint:disable force_cast
        UIApplication.shared.delegate as! AppDelegate
    }

    static var keyWindow: UIWindow? {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first
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
