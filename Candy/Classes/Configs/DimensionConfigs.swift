//
//  DimensionConfigs.swift

import UIKit

public extension CGFloat {

    /// safeAreaInsets Top
    static var safeAreaTop: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.keyWindow?.rootViewController?.topLayoutGuide.length ?? 0
        }
    }

    /// safeAreaInsets Bottom
    static var safeAreaBottom: CGFloat {

        if #available(iOS 11.0, *) {
            return UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.keyWindow?.rootViewController?.bottomLayoutGuide.length ?? 0
        }
    }

    /// navigationBar 底部的 Y 值
    static var navigationBarBottomY: CGFloat {
        .navigationBarHeight + .safeAreaTop
    }

    /// tabBar 顶部的 Y 值
    static var tabBarTopY: CGFloat {
        .tabBarHeight + .safeAreaBottom
    }

    static var safeAreaTopAndBottom: CGFloat {
        safeAreaTop + safeAreaBottom
    }

    /// navigationBar 高度
    static var navigationBarHeight: CGFloat {
        UIApplication.rootViewController?.navigationController?.navigationBar.size.height ?? 0
    }

    /// tabBar 高度
    static var tabBarHeight: CGFloat {
        UIApplication.rootViewController?.tabBarController?.tabBar.size.height ?? 0
    }

    static var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }

    static var screenHeight: CGFloat {
        UIScreen.main.bounds.size.height
    }

    static var scale: CGFloat {
        UIScreen.main.scale
    }
}
