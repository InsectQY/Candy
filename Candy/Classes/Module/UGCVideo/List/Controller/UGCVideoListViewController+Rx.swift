//
//  UGCVideoListViewController+Rx.swift
//  Candy
//
//  Created by QY on 2019/3/27.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

// MARK: - Reactive-Extension
extension Reactive where Base: UGCVideoListViewController {

    var postNotification: Binder<Void> {
        return Binder(base) { _, _ in
            NotificationCenter.default
            .post(name: Notification.UGCVideoNoConnectClick, object: nil)
        }
    }
}
