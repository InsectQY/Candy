//
//  ViewController+Rx.swift
//  Candy
//
//  Created by Insect on 2020/6/24.
//  Copyright © 2020 Insect. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - Reactive-Extension
extension Reactive where Base: ViewController {

    var isLoading: Binder<Bool> {

        Binder(base) { target, value in
            target.startLoading(isLoading: value)
        }
    }
}
