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
        libsManager.setupReachability()
    }

    // MARK: - IQKeyboardManager
    func setupKeyboardManager() {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    // MARK: - Kingfisher
    func setupKingfisher() {

        // 15 sec
        ImageDownloader.default.downloadTimeout = Configs.Time.imageDownloadTimeout
//        ImageCache.default.maxMemoryCost = 1
    }

    // MARK: - NVActivityIndicatorView
    func setupActivityView() {

        NVActivityIndicatorView.DEFAULT_TYPE = .ballRotateChase
        NVActivityIndicatorView.DEFAULT_COLOR = .main
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = .clear
    }

    // MARK: - RxNetwork
    func setupNetwork() {

        Network.Configuration.default.timeoutInterval = Configs.Time.netWorkTimeout
        Network.Configuration.default.plugins = [CustomResponsePlugin()]
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
        ToastManager.shared.style.messageFont = .pingFangSCMedium(18)
    }

    func setupReachability() {
        ReachabilityManager.shared.startNotifier()
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
