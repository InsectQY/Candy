//
//  not.swift
//  Candy
//
//  Created by Insect on 2019/5/27.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        self.map(!)
    }
}

extension SharedSequenceConvertibleType where Element == Bool {
    /// Boolean not operator.
    public func not() -> SharedSequence<SharingStrategy, Bool> {
        map(!)
    }
}
