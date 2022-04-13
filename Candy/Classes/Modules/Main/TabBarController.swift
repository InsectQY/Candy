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
            let vcName = dict["vcName"] as? String
            let normalImage = dict["normalImage"] as? String
            let selectedImage = dict["selectedImage"] as? String
            let title = dict["title"] as? String
            let navigationName = dict["navigationName"] as? String

            addChildVc(vcName: vcName,
                       title: title,
                       normalImage: normalImage,
                       selectedImage: selectedImage,
                       navigationName: navigationName)
        }
    }

    // 添加子控制器
    private func addChildVc(vcName: String?,
                            title: String?,
                            normalImage: String?,
                            selectedImage: String?,
                            navigationName: String?) {
        guard
            let vcName = vcName,
            let childVc: UIViewController = vcName.classObject()
        else {
            assert(false, "UIViewController not init")
            return
        }

        childVc.tabBarItem.image = UIImage(named: normalImage ?? "")
        childVc.tabBarItem.selectedImage = UIImage(named: selectedImage ?? "")
        childVc.tabBarItem.title = title

        if
            let navigationName = navigationName,
            let navigation: UINavigationController.Type = navigationName.classType() {
            addChild(navigation.init(rootViewController: childVc))
        } else {
            addChild(childVc)
        }
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
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
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
