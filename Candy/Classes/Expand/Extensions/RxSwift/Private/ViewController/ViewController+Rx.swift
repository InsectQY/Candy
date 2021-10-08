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
public extension Reactive where Base: UIViewController {
    
    var isLoading: Binder<Bool> {
        Binder(base) { target, value in
            if value {
                target.view.startLoading()
            } else {
                target.view.stopLoading()
            }
        }
    }

    var showError: Binder<Error> {

        Binder(base) { vc, error in
            vc.view.show(error.asMoyaError?.responseErrorDescription ?? "网络请求失败")
        }
    }
}
