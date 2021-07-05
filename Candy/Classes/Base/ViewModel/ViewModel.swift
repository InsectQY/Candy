//
//  BaseViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

/// 轻量级 ViewModel，只包含了 error 和耗时操作状态
class ViewModel {

    /// 是否正在加载
    let loading = ActivityIndicator()
    /// track error
    let error = ErrorTracker()

    required init() {}

    deinit {
        print("\(type(of: self)): deinit")
    }
}

extension ViewModel: HasDisposeBag {}
