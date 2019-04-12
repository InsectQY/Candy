//
//  RefreshViewModel.swift
//  Candy
//
//  Created by Insect on 2019/4/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

class RefreshViewModel: ViewModel {

    /// 刷新过程中产生的 error
    let refreshError = ErrorTracker()
    /// 头部刷新状态
    let headerRefreshState = PublishSubject<Bool>()
    /// 尾部刷新状态
    let footerRefreshState = PublishSubject<RxMJRefreshFooterState>()

    override func bindState() {
        super.bindState()

        unified?.bindHeaderRefresh(with: headerRefreshState)
        unified?.bindFooterRefresh(with: footerRefreshState)
        unified?.bindLoading(with: loading)
        bindErrorToRefreshHeaderState()
    }
}

extension RefreshViewModel {

    /// 刷新控件发生 error 时的 header 状态
    public func bindErrorToRefreshHeaderState() {

        refreshError
        .map { _ in false }
        .drive(headerRefreshState)
        .disposed(by: disposeBag)
    }

    /// 刷新控件发生 error 时的 footer 状态
    public func bindErrorToRefreshFooterState(_ isItemsEmpty: Bool) {

        refreshError
        .map { _ in isItemsEmpty ? RxMJRefreshFooterState.hidden : RxMJRefreshFooterState.default }
        .drive(footerRefreshState)
        .disposed(by: disposeBag)
    }
}

extension RefreshViewModel {

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
