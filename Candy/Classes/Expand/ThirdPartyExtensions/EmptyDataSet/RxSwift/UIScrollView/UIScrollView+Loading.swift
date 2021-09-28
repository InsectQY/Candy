//
//  UIScrollView+Loading.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import RxSwift
import UIKit
import EmptyDataSet_Swift

// MARK: - Reactive-Extension

extension EmptyDataSetWrapper: ReactiveCompatible {}

extension Reactive where Base: EmptyDataSetWrapper {

    var isLoading: Binder<Bool> {
        Binder(base) { target, value in
            target.config?.isLoading = value
        }
    }

    func didTapView() -> ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in

            MainScheduler.ensureRunningOnMainThread()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            control.config?.didTapView = {
                observer.on(.next(()))
            }

            return Disposables.create()
        }
            .takeUntil(deallocated)

        return ControlEvent(events: source)
    }
}
