//
//  TabBarController.swift
//  HelloSVU_Swift
//
//  Created by Insect on 2017/5/23.
//  Copyright © 2017年 Insect. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        seUpTabBarAttr()

        guard
            let jsonPath = R.file.mainVCSettingsJson()?.path,
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)),
            let anyObject = try? JSONSerialization.jsonObject(with: jsonData,
                                                              options: .mutableContainers),
            let dictArray: [[String: Any]] = anyObject as? [[String: Any]]
        else {
            return
        }

        for dict in dictArray {

            guard let vcName = dict["vcName"] as? String else { continue }
            guard let normalImg = dict["normalImg"] as? String else { continue }
            guard let selImg = dict["selImg"] as? String else { continue }
            guard let title = dict["title"] as? String else { continue }

            addChildVc(childVcName: vcName, title: title, normalImg: normalImg, selImg: selImg)
        }
    }

    // 添加子控制器
    private func addChildVc(childVcName: String,
                            title: String,
                            normalImg: String,
                            selImg: String) {

        guard let childVc: UIViewController = childVcName.classObject()
        else {
            assert(false, "error: \(childVcName) not init")
            return
        }

        childVc.tabBarItem.image = UIImage(named: normalImg)
        childVc.tabBarItem.selectedImage = UIImage(named: selImg)
        childVc.tabBarItem.title = title

        let childNav = NavigationController(rootViewController: childVc)

        addChild(childNav)
    }

    // 设置 TabBar 属性
    private func seUpTabBarAttr() {

        if #available(iOS 13.0, *) {
            tabBar.tintColor = UIColor.main
            tabBar.unselectedItemTintColor = UIColor.tabBarNormal
        } else {
            UITabBarItem.appearance()
                .setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabBarNormal], for: .normal)
            UITabBarItem.appearance()
                .setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.main], for: .selected)
        }

        tabBar.hero.modifiers = [.useGlobalCoordinateSpace,
                                 .useNoSnapshot,
                                 .zPosition(10),
                                 .translate(x: 0, y: 100, z: 0)]
    }

    deinit {
        print("deinit: \(self)")
    }
}
