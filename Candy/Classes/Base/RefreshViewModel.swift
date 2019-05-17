//
//  RefreshViewModel.swift
//  Candy
//
//  Created by Insect on 2019/4/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

/// 专用于处理刷新状态的 VM, 如不需要可继承更轻量的 ViewModel
class RefreshViewModel: ViewModel {

    let refreshInput: RefreshInput
    let refreshOutput: RefreshOutput

    struct RefreshInput {

        /// 开始头部刷新
        let beginHeaderRefresh: AnyObserver<Void>
        /// 开始尾部刷新
        let beginFooterRefresh: AnyObserver<Void>

        /// 头部刷新状态
        let headerRefreshState: AnyObserver<Bool>
        /// 尾部刷新状态
        let footerRefreshState: AnyObserver<RxMJRefreshFooterState>
    }

    struct RefreshOutput {

        /// 头部刷新回调
        let headerRefreshing: Driver<Void>
        /// 尾部刷新回调
        let footerRefreshing: Driver<Void>

        /// 头部刷新状态
        let headerRefreshState: Driver<Bool>
        /// 尾部刷新状态
        let footerRefreshState: Driver<RxMJRefreshFooterState>
    }

    /// 开始头部刷新
    private let beginHeaderRefresh = PublishSubject<Void>()
    /// 开始尾部刷新
    private let beginFooterRefresh = PublishSubject<Void>()
    /// 头部刷新状态
    private let headerRefreshState = PublishSubject<Bool>()
    /// 尾部刷新状态
    private let footerRefreshState = PublishSubject<RxMJRefreshFooterState>()

    /// 刷新过程中产生的 error
    let refreshError = ErrorTracker()
    override init() {
        refreshInput = RefreshInput(beginHeaderRefresh: beginHeaderRefresh.asObserver(),
                                    beginFooterRefresh: beginFooterRefresh.asObserver(),
                                    headerRefreshState: headerRefreshState.asObserver(),
                                    footerRefreshState: footerRefreshState.asObserver())
        refreshOutput = RefreshOutput(headerRefreshing: beginHeaderRefresh.asDriverOnErrorJustComplete(),
                                      footerRefreshing: beginFooterRefresh.asDriverOnErrorJustComplete(),
                                      headerRefreshState: headerRefreshState.asDriverOnErrorJustComplete(),
                                      footerRefreshState: footerRefreshState.asDriverOnErrorJustComplete())

        super.init()
    }

    func bindState() {

//        unified?.bindHeaderRefresh(with: headerRefreshState)
//        unified?.bindFooterRefresh(with: footerRefreshState)
//        unified?.bindLoading(with: loading)
//        bindErrorToRefreshHeaderState()
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
        .map { _ in
            isItemsEmpty ? RxMJRefreshFooterState.hidden : RxMJRefreshFooterState.default
        }
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
