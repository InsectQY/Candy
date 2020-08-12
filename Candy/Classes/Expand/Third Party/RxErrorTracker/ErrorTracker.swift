//
// Created by sergdort on 03/02/2017.
// Copyright (c) 2017 sergdort. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final public class ErrorTracker: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    fileprivate func trackErrorOfObservable<Source: ObservableConvertibleType>(from source: Source) -> Observable<Source.Element> {
        return source.asObservable().do(onError: onError)
    }

    fileprivate func trackErrorOfSingle<Element>(from source: Single<Element>) -> Single<Element> {
        return source.do(onError: onError)
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    public func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

public extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackErrorOfObservable(from: self)
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    func trackError(_ errorTracker: ErrorTracker) -> Single<Element> {
        return errorTracker.trackErrorOfSingle(from: self)
    }
}
