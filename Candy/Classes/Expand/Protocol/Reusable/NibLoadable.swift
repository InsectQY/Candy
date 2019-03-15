//
//  NibLoadable.swift
//  Copyright © 2018年 Insect. All rights reserved.
//  swiftlint:disable force_cast
//  swiftlint:disable force_unwrapping

import UIKit

public protocol NibLoadable {

    static var Nib: UINib { get }
}

extension NibLoadable where Self: UIView {

    static var Nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }

    static func loadFromNib(_ nibname: String? = nil) -> Self {

        let loadName = nibname == nil ? "\(self)": nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}
