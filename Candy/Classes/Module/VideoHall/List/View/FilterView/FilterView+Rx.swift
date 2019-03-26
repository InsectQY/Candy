//
//  FilterView+Rx.swift
//  Candy
//
//  Created by apple on 2019/3/26.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

// MARK: - Reactive-extension
public extension Reactive where Base: FilterView {

    var categories: Binder<[CategoryList]> {
        return Binder(base) { view, result in
            view.filter = result
        }
    }
}
