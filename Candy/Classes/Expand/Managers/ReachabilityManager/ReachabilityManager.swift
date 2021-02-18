//
//  ReachabilityManager.swift
//  Candy
//
//  Created by Insect on 2020/6/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

import RxReachability
import Reachability

public class ReachabilityManager {

    /// 当前连接的网络类型
    public let reachabilityConnection: BehaviorRelay<Reachability.Connection> = BehaviorRelay(value: .unavailable)
    /// Singleton
    public static let shared = ReachabilityManager()

    /// 监听网络状态改变
    private lazy var reachability: Reachability? = try? Reachability()

    init() {
        trackReachabilityState()
    }

    private func trackReachabilityState() {

        reachability?.rx.reachabilityChanged
        .map(\.connection)
        .bind(to: reachabilityConnection)
        .disposed(by: disposeBag)
    }

    public func startNotifier() {
        try? reachability?.startNotifier()
    }
}

extension ReachabilityManager: HasDisposeBag {}
