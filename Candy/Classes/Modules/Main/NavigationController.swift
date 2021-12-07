//
//  NavigationController.swift
//  HelloSVU_Swift
//
//  Created by Insect on 2017/5/23.
//  Copyright © 2017年 Insect. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // iOS 13
        modalPresentationStyle = .fullScreen
        // 全屏滑动返回
        fd_fullscreenPopGestureRecognizer.isEnabled = true
        // 转场动画
        hero.isEnabled = true
        // 导航栏背景和文字设置
        let navigationBar = UINavigationBar.appearance()
        navigationBar.qy.backgroundColor = .main
        navigationBar.qy.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if children.count >= 1 {

            let backItem = BarButtonItem(image: R.image.leftbackicon_white_titlebar_24x24_(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backBtnDidClick))
            viewController.navigationItem.leftBarButtonItem = backItem
            // 隐藏要push的控制器的tabBar
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }

    deinit {
        print("\(type(of: self)): deinit")
    }
}

// MARK: - 返回点击事件
extension NavigationController {

    @objc private func backBtnDidClick() {
        popViewController(animated: true)
    }
}
