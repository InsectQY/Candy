//
//  BindLoadStateable.swift
//  Candy
//
//  Created by Insect on 2019/4/12.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public protocol BindLoadStateable: class {

    /// 加载状态绑定给是否正在加载
    func bindLoading(with loading: ActivityIndicator)
    /// 加载状态绑定给正在加载指示器
    func bindShowIndicator(with loading: ActivityIndicator)
}

extension BindLoadStateable {

    func bindLoading(with loading: ActivityIndicator) {}
    func bindShowIndicator(with loading: ActivityIndicator) {}
}
