//
//  DictionaryExtension.swift
//  QYNews
//
//  Created by QY on 2019/2/9.
//  Copyright © 2019年 Insect. All rights reserved.
//

import Foundation

typealias TypedUserInfoKey<T> = (key: String, type: T.Type)

extension Dictionary where Key == String, Value == Any {
    subscript<T>(_ typedKey: TypedUserInfoKey<T>) -> T? {
        self[typedKey.key] as? T
    }
}
