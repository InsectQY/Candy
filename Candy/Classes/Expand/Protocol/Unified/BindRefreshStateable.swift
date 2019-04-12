//
//  BindRefreshStateable.swift
//  Candy
//
//  Created by Insect on 2019/4/12.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public protocol BindRefreshStateable: class {

    /// 绑定头部刷新状态
    func bindHeaderRefresh(with state: Observable<Bool>)
    /// 绑定尾部刷新状态
    func bindFooterRefresh(with state: Observable<RxMJRefreshFooterState>)
}

extension BindRefreshStateable {

    func bindHeaderRefresh(with state: Observable<Bool>) {}
    func bindFooterRefresh(with state: Observable<RxMJRefreshFooterState>) {}
    func bindLoading(with loading: ActivityIndicator) {}
}
