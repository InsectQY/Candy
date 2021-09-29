//
//  EmptyDataSetCompatible.swift
//  Candy
//
//  Created by Insect on 2021/9/29.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation
import UIKit

public protocol EmptyDataSetCompatible {

    associatedtype T

    var emptyDataSet: EmptyDataSetWrapper<T> { get }
}

public extension EmptyDataSetCompatible {

    var emptyDataSet: EmptyDataSetWrapper<Self> {
        return EmptyDataSetWrapper(self)
    }

    static var emptyDataSet: EmptyDataSetWrapper<Self>.Type {
        return EmptyDataSetWrapper<Self>.self
    }
}

extension UIScrollView: EmptyDataSetCompatible {}
