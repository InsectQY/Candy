//
//  UIViewController+JXCategoryView.swift
//  Candy
//
//  Created by Insect on 2020/6/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation
import JXCategoryView

extension UIViewController: JXCategoryListContentViewDelegate {

    // MARK: - JXCategoryListContentViewDelegate
    public func listView() -> UIView! {
        view
    }
}
