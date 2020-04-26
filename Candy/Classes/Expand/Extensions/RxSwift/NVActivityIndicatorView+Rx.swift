//
//  NVActivityIndicatorView+Rx.swift
//  Candy
//
//  Created by Insect on 2019/5/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension Reactive where Base: ViewModel {

    var isAnimating: Binder<Bool> {
        Binder(self.base) { vc, active in
            if active {
                NVActivityIndicatorPresenter
                .sharedInstance
                .startAnimating(ActivityData())
            } else {
                NVActivityIndicatorPresenter
                .sharedInstance
                .stopAnimating()
            }
        }
    }
}
