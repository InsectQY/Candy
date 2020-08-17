//
//  filterMany.swift
//  Candy
//
//  Created by Insect on 2020/8/17.
//  Copyright © 2020 Insect. All rights reserved.
//

import RxSwift

extension ObservableType where Element: Collection {
    /**
     Projects each element of an observable collection into a new form.

     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    public func filterMany(_ isIncluded: @escaping (Element.Element) throws -> Bool) -> Observable<[Element.Element]> {
        return map { collection -> [Element.Element] in
            try collection.filter(isIncluded)
        }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait, Element: Collection {
    /**
     Projects each element of an observable collection into a new form.

     - parameter transform: A transform function to apply to each element of the source collection.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */
    func filterMany(_ isIncluded: @escaping (Element.Element) throws -> Bool) -> PrimitiveSequence<SingleTrait, [Element.Element]> {
        return map { collection -> [Element.Element] in
            try collection.filter(isIncluded)
        }
    }
}

public extension SharedSequenceConvertibleType where Element: Collection {
    func filterMany(_ isIncluded: @escaping (Element.Element) -> Bool) -> SharedSequence<SharingStrategy, [Element.Element]> {
        return map { collection -> [Element.Element] in
            collection.filter(isIncluded)
        }
    }
}
