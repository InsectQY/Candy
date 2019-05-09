//
//  BaseViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

class ViewModel {

    weak var unified: Unifiedable?
    /// 是否正在加载
    let loading = ActivityIndicator()
    /// track error
    let error = ErrorTracker()

    init(unified: Unifiedable? = nil) {
        self.unified = unified
        bindState()
    }

    func bindState() {
        unified?.bindErrorToShowToast(error)
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
}

extension ViewModel: HasDisposeBag {}
