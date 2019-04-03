//
//  Refreshable.swift
//  Candy
//
//  Created by Insect on 2019/4/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

protocol Refreshable: class {

    /// 头部刷新回调
    var header: ControlEvent<Void> { get }
    /// 尾部刷新回调
    var footer: ControlEvent<Void> { get }
}
