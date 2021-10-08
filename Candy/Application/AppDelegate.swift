//
//  AppDelegate.swift
//  QYNews
//
//  Created by Insect on 2018/12/3.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    open var isAllowOrientationRotation: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        LibsManager.setupLibs(with: window)
        initRootViewController()
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        isAllowOrientationRotation ? .allButUpsideDown : .portrait
    }
}
