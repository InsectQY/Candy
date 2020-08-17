//
//  VideoHallViewController+Rx.swift
//  Candy
//
//  Created by Insect on 2020/8/17.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

// MARK: - Reactive-extension
extension Reactive where Base: VideoHallViewController {

    var filterTap: Binder<Void> {

        Binder(base) { vc, _ in
            vc.filterTap()
        }
    }

    var filterViewHeight: Binder<CGFloat> {

        Binder(base) { vc, value in
            vc.setFilterViewHeight(value)
        }
    }
}
