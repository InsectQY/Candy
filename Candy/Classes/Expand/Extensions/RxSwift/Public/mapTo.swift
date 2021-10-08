//
//  mapTo.swift
//  RxSwiftExt
//
//  Created by Marin Todorov on 4/12/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxMJ

extension ObservableType {

    public func mapToVoid() -> Observable<Void> {
        map { _ in }
    }

    public func mapToFooterStateDefault() -> Observable<RxMJRefreshFooterState> {
        map { _ in RxMJRefreshFooterState.default }
    }
}

extension SharedSequenceConvertibleType {

    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }

    public func mapToFooterStateDefault() -> SharedSequence<SharingStrategy, RxMJRefreshFooterState> {
        map { _ in RxMJRefreshFooterState.default }
    }
}
