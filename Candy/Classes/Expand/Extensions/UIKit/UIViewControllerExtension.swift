//
//  UIViewControllerExtension.swift
//  Candy
//
//  Created by Insect on 2019/5/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import JXCategoryView

extension UIViewController: JXCategoryListContentViewDelegate {

    // MARK: - JXCategoryListContentViewDelegate
    public func listView() -> UIView! {
        view
    }

    public func disablesAdjustScrollViewInsets(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
