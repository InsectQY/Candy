//
//  catchErrorJustComplete.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 21/05/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableType {

    public func catchErrorJustComplete() -> Observable<Element> {
        `catch` { _ in
            Observable.empty()
        }
    }

    public func asDriverOnErrorJustComplete() -> Driver<Element> {

        asDriver { error in
            Driver.empty()
        }
    }
}
