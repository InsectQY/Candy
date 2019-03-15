//
//  AppDelegate.swift
//  QYNews
//
//  Created by Insect on 2018/12/3.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import MonkeyKing

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        LibsManager.shared.setupLibs(with: window)
        initRootViewController()
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {

        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        return false
    }
}
