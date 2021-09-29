//
//  UIScrollView+Loading.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import EmptyDataSet_Swift
import RxSwift
import UIKit

// MARK: - Reactive-Extension

extension EmptyDataSetConfig: ReactiveCompatible {}

extension Reactive where Base: EmptyDataSetConfig {

    var isLoading: Binder<Bool> {
        Binder(base) { target, value in
            target.isLoading = value
        }
    }

    var didTapView: ControlEvent<Void> {

        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in

            MainScheduler.ensureRunningOnMainThread()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            control.didTapView = {
                observer.on(.next(()))
            }

            return Disposables.create()
        }
            .takeUntil(deallocated)

        return ControlEvent(events: source)
    }
}
