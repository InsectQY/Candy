//
//  ViewController+Rx.swift
//  Candy
//
//  Created by Insect on 2020/6/24.
//  Copyright © 2020 Insect. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

// MARK: - Reactive-Extension
public extension Reactive where Base: UIView {
    
    var isLoading: Binder<Bool> {
        Binder(base) { target, value in
            if value {
                target.startLoading()
            } else {
                target.stopLoading()
            }
        }
    }

    var showError: Binder<Error> {

        Binder(base) { vc, error in
            vc.show("网络请求失败")
        }
    }
}
