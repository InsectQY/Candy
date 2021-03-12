//
//  ViewController+Rx.swift
//  Candy
//
//  Created by Insect on 2020/6/24.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Reactive-Extension
extension Reactive where Base: ViewController {

    var isLoading: Binder<Bool> {

        Binder(base) { target, value in
            target.isLoading = value
        }
    }

    func emptyDataSetDidTapView() -> ControlEvent<()> {

        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in

            MainScheduler.ensureRunningOnMainThread()
            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            control.emptyDataSetDidTapView = {
                observer.on(.next(()))
            }

            return Disposables.create()
        }
        .takeUntil(deallocated)

        return ControlEvent(events: source)
    }
}
