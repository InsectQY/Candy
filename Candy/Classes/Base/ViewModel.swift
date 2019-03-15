//
//  BaseViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

class ViewModel {

    let loading = ActivityIndicator()
    let error = ErrorTracker()

    deinit {
        print("\(type(of: self)): Deinited")
    }
}

extension ViewModel {

    public func footerState(_ isHasMore: Bool, isEmpty: Bool) -> RxMJRefreshFooterState {

        if !isHasMore && !isEmpty {
            return .noMoreData
        } else if !isHasMore && isEmpty {
            return .hidden
        } else {
            return .default
        }
    }
}

extension ViewModel: HasDisposeBag {}
