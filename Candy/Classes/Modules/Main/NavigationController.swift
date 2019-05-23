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

        // 全屏滑动返回
        fd_fullscreenPopGestureRecognizer.isEnabled = true

        // 导航栏背景和文字设置
        let naviBar: UINavigationBar = UINavigationBar.appearance()
        naviBar.barTintColor = .main
        naviBar.titleTextAttributes = {[

            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.pingFangSCMedium(17)
        ]}()
        view.backgroundColor = .white
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if children.count >= 1 {

            viewController.navigationItem.leftBarButtonItem = BarButtonItem(image: R.image.leftbackicon_white_titlebar_24x24_(), style: .plain, target: self, action: #selector(backBtnDidClick))
            // 隐藏要push的控制器的tabbar
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 返回点击事件
extension NavigationController {

    @objc private func backBtnDidClick() {
        popViewController(animated: true)
    }
}
