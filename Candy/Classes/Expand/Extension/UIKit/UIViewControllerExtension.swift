//
//  UIViewControllerExtension.swift
//  Candy
//
//  Created by apple on 2019/5/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import JXCategoryView

extension UIViewController: JXCategoryListContentViewDelegate {

    // MARK: - JXCategoryListContentViewDelegate
    public func listView() -> UIView! {
        return view
    }
}
