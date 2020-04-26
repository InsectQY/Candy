//
//  HUD+Rx.swift
//  NewRetailPlatform
//
//  Created by QY on 2020/4/26.
//  Copyright © 2020 RocketsChen. All rights reserved.
//

import Foundation

extension Reactive where Base: ViewModel {

    var isShowLoadingIndicator: Binder<Bool> {
        Binder(self.base) { vc, active in
            if active {
                HUD.startLoading()
            } else {
                HUD.stopLoading()
            }
        }
    }
}

extension Reactive where Base: NSObject {

    var isShowLoadingIndicator: Binder<Bool> {
        Binder(self.base) { vc, active in
            if active {
                HUD.startLoading()
            } else {
                HUD.stopLoading()
            }
        }
    }
}
