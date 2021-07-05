//
//  FilterView+Rx.swift
//  Candy
//
//  Created by Insect on 2019/3/26.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

// MARK: - Reactive-extension
public extension Reactive where Base: FilterView {

    var categories: Binder<[CategoryList]> {
        Binder(base) { view, result in
            view.filter = result
        }
    }
}
