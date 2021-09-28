//
//  UINavigationBarCompatible.swift
//  Scanking
//
//  Created by Scanking on 2021/09/15.
//  Copyright © 2021 Scanking. All rights reserved.
//

import UIKit

public protocol UINavigationBarCompatible {

    associatedtype T

    var qy: UINavigationBarWrapper<T> { get }
}

public extension UINavigationBarCompatible {

    var qy: UINavigationBarWrapper<Self> {
        return UINavigationBarWrapper(self)
    }

    static var qy: UINavigationBarWrapper<Self>.Type {
        return UINavigationBarWrapper<Self>.self
    }
}

extension UINavigationBar: UINavigationBarCompatible {}
