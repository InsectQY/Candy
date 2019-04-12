//
//  RefreshComponentable.swift
//  Candy
//
//  Created by Insect on 2019/4/12.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public protocol RefreshComponentable: class {

    /// 头部刷新回调
    var header: ControlEvent<Void> { get }
    /// 尾部刷新回调
    var footer: ControlEvent<Void> { get }
}

extension RefreshComponentable {

    var header: ControlEvent<Void> {
        return ControlEvent(events: Observable.empty())
    }

    var footer: ControlEvent<Void> {
        return ControlEvent(events: Observable.empty())
    }
}
