//
//  JXCategoryView+Rx.swift
//  Candy
//
//  Created by Insect on 2020/8/14.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation
import JXCategoryView

// MARK: - Reactive-Extension
extension Reactive where Base: JXCategoryTitleView {
    var titles: Binder<[String]> {
        Binder(base) { target, value in
            target.titles = value
            target.reloadData()
        }
    }
}
