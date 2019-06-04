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

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType where E == Bool {
    /// Boolean not operator.
    public func not() -> SharedSequence<SharingStrategy, Bool> {
        return map(!)
    }
}
