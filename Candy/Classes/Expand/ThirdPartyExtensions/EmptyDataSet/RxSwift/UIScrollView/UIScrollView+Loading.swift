//
//  UIScrollView+Loading.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import RxSwift
import UIKit

// MARK: - Reactive-Extension

extension Reactive where Base: UIScrollView {
    var isLoading: Binder<Bool> {
        Binder(base) { target, value in
            target.isLoading = value
        }
    }

    func emptyDataSetDidTapView() -> ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in

            MainScheduler.ensureRunningOnMainThread()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            control.emptyDataSet?.didTapView = {
                observer.on(.next(()))
            }

            return Disposables.create()
        }
        .takeUntil(deallocated)

        return ControlEvent(events: source)
    }
}
