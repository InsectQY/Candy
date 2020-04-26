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

    /// 刷新过程中产生的 error
    let refreshError = ErrorTracker()

    struct RefreshInput {

        /// 开始头部刷新
        let beginHeaderRefresh: AnyObserver<Void>
        /// 开始尾部刷新
        let beginFooterRefresh: AnyObserver<Void>

        /// 头部刷新状态
        let headerRefreshState: AnyObserver<Bool>
        /// 尾部刷新状态
        let footerRefreshState: AnyObserver<RxMJRefreshFooterState>

        /// 没有网络时的点击事件
        let emptyDataSetViewTap: AnyObserver<Void>
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

        /// 没有网络时点击事件回调
        let emptyDataSetViewTap: Driver<Void>
    }

    /// 开始头部刷新
    private let beginHeaderRefresh = PublishSubject<Void>()
    /// 开始尾部刷新
    private let beginFooterRefresh = PublishSubject<Void>()
    /// 头部刷新状态
    private let headerRefreshState = PublishSubject<Bool>()
    /// 尾部刷新状态
    private let footerRefreshState = PublishSubject<RxMJRefreshFooterState>()

    /// 没有网络点击占位
    private let emptyDataSetViewTap = PublishSubject<Void>()

    required init() {

        refreshInput = RefreshInput(beginHeaderRefresh: beginHeaderRefresh.asObserver(),
                                    beginFooterRefresh: beginFooterRefresh.asObserver(),
                                    headerRefreshState: headerRefreshState.asObserver(),
                                    footerRefreshState: footerRefreshState.asObserver(),
                                    emptyDataSetViewTap: emptyDataSetViewTap.asObserver())
        refreshOutput = RefreshOutput(headerRefreshing: beginHeaderRefresh.asDriverOnErrorJustComplete(),
                                      footerRefreshing: beginFooterRefresh.asDriverOnErrorJustComplete(),
                                      headerRefreshState: headerRefreshState.asDriverOnErrorJustComplete(),
                                      footerRefreshState: footerRefreshState.asDriverOnErrorJustComplete(),
                                      emptyDataSetViewTap: emptyDataSetViewTap.asDriverOnErrorJustComplete())

        super.init()
    }

    /// 希望在 init 完成后才监听的事件，放到这个方法里。
    /// 这个方法的目的：如果在 init 时就发出了序列，可能外部还没有监听。等外部全部监听完成后，再手动调用该方法
    func bindState() {

    }
}

extension RefreshViewModel {

    public func footerState(_ isHasMore: Bool,
                            isEmpty: Bool) -> RxMJRefreshFooterState {

        if !isHasMore && !isEmpty {
            return .noMoreData
        } else if !isHasMore && isEmpty {
            return .hidden
        } else {
            return .default
        }
    }
}
