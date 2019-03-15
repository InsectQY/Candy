//
//  Reusable.swift
//  Copyright © 2017年 Insect. All rights reserved.
//

import UIKit

public protocol Reusable {

    static var ID: String { get }
}

public typealias NibReusable = Reusable & NibLoadable

extension Reusable {

    static var ID: String {
        return String(describing: Self.self)
    }
}
