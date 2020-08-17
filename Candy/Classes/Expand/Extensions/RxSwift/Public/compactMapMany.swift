//
//  compactMapMany.swift
//  Candy
//
//  Created by Insect on 2020/8/17.
//  Copyright © 2020 Insect. All rights reserved.
//

import RxSwift

public extension ObservableType where Element: Collection {
    /**
     Projects each element of an observable collection into a new form.

     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    func compactMapMany<Result>(_ transform: @escaping (Element.Element) throws -> Result) -> Observable<[Result]> {
        return compactMap { collection -> [Result] in
            try collection.compactMap(transform)
        }
    }
}

public extension SharedSequenceConvertibleType where Element: Collection {
    func compactMapMany<Result>(_ transform: @escaping (Element.Element) -> Result) -> SharedSequence<SharingStrategy, [Result]> {
        return compactMap { collection -> [Result] in
            collection.compactMap(transform)
        }
    }
}
