//
//  AppDelegate+Root.swift
//  SSDispatch
//
//  Created by insect_qy on 2018/9/13.
//  Copyright © 2018年 insect_qy. All rights reserved.
//

import Foundation

extension AppDelegate {

    // MARK: - 设置根控制器
    func initRootViewController() {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {

    static func shared() -> AppDelegate {
        // swiftlint:disable force_cast
        UIApplication.shared.delegate as! AppDelegate
    }
}
