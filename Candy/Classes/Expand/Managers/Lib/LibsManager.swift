//
//  LibsManager.swift
//  QYNews
//
//  Created by Insect on 2019/1/28.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import Kingfisher
import RxNetwork
import Moya
import Toast_Swift

class LibsManager {

    static func setupLibs(with window: UIWindow? = nil) {

        setupKeyboardManager()
        setupNetwork()
        setupRouter()
        setupToast()
        setupReachability()
    }

    // MARK: - IQKeyboardManager
    static func setupKeyboardManager() {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    // MARK: - Kingfisher
    static func setupKingfisher() {

        // 15 sec
        ImageDownloader.default.downloadTimeout = Configs.Time.imageDownloadTimeout
//        ImageCache.default.maxMemoryCost = 1
    }

    // MARK: - RxNetwork
    static func setupNetwork() {

        Network.Configuration.default.timeoutInterval = Configs.Time.netWorkTimeout
        Network.Configuration.default.plugins = [CustomResultPlugin()]
    }

    static func setupRouter() {
        NavigationMap.initRouter()
    }

    static func setupToast() {
        ToastManager.shared.position = .center
        ToastManager.shared.style.messageFont = .systemFont(ofSize: 18)
    }

    static func setupReachability() {
        ReachabilityManager.shared.startNotifier()
    }
}
