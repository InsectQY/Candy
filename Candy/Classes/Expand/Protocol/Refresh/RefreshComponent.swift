//
//  Refreshable.swift
//  Candy
//
//  Created by Insect on 2019/4/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public typealias Refreshable = RefreshComponent & BindRefreshState

public protocol RefreshComponent: class {

    /// 头部刷新回调
    var header: ControlEvent<Void> { get }
    /// 尾部刷新回调
    var footer: ControlEvent<Void> { get }
}

public protocol BindRefreshState: class {

    /// 绑定头部刷新状态
    func bindHeaderRefresh(with state: Observable<Bool>)
    /// 绑定尾部刷新状态
    func bindFooterRefresh(with state: Observable<RxMJRefreshFooterState>)
}

extension RefreshComponent {

    var header: ControlEvent<Void> {
        return ControlEvent(events: Observable.empty())
    }

    var footer: ControlEvent<Void> {
        return ControlEvent(events: Observable.empty())
    }
}

extension BindRefreshState {

    func bindHeaderRefresh(with state: Observable<Bool>) {}
    func bindFooterRefresh(with state: Observable<RxMJRefreshFooterState>) {}
}
