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
import MonkeyKing
import Moya
import Toast_Swift

class LibsManager: NSObject {

    static let shared = LibsManager()

    func setupLibs(with window: UIWindow? = nil) {

        let libsManager = LibsManager.shared
        libsManager.setupKeyboardManager()
        libsManager.setupActivityView()
        libsManager.setupMonkeyKing()
        libsManager.setupNetwork()
        libsManager.setupRouter()
        libsManager.setupToast()
    }

    // MARK: - IQKeyboardManager
    func setupKeyboardManager() {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    // MARK: - Kingfisher
    func setupKingfisher() {

        // 500 MB
        ImageCache.default.maxDiskCacheSize = UInt(500 * 1024 * 1024)
        // 1 week
        ImageCache.default.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 7)
        // 15 sec
        ImageDownloader.default.downloadTimeout = 15.0
//        ImageCache.default.maxMemoryCost = 1
    }

    // MARK: - NVActivityIndicatorView
    func setupActivityView() {

        NVActivityIndicatorView.DEFAULT_TYPE = .ballRotateChase
        NVActivityIndicatorView.DEFAULT_COLOR = .main
    }

    // MARK: - RxNetwork
    func setupNetwork() {

        Network.Configuration.default.timeoutInterval = 20
        Network.Configuration.default.plugins = [ErrorPlugin()]
    }

    // MARK: - MonkeyKing
    func setupMonkeyKing() {
        MonkeyKing.registerAccount(.weChat(appID: Keys.weChat.appID,
                                           appKey: Keys.weChat.appKey,
                                           miniAppID: nil))
    }

    func setupRouter() {
        NavigationMap.initRouter()
    }

    func setupToast() {
        ToastManager.shared.position = .center
        ToastManager.shared.style.messageFont = .systemFont(ofSize: 18)
    }
}

extension LibsManager {

    func removeKingfisherCache(completion handler: (() -> Void)?) {

        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            handler?()
        }
    }
}
