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

        /// 接收头部刷新事件
        let headerRefreshOb: AnyObserver<Void>
        /// 接收尾部刷新事件
        let footerRefreshOb: AnyObserver<Void>

        /// 接收头部刷新状态
        let headerRefreshStateOb: AnyObserver<Bool>
        /// 接收尾部刷新状态
        let footerRefreshStateOb: AnyObserver<RxMJRefreshFooterState>

        /// 接收数据源空时的点击事件
        let emptyDataSetViewTapOb: AnyObserver<Void>
    }

    struct RefreshOutput {

        /// 头部刷新回调
        let headerRefreshing: Driver<Void>
        /// 尾部刷新回调
        let footerRefreshing: Driver<Void>

        /// 头部刷新状态回调
        let headerRefreshState: Driver<Bool>
        /// 尾部刷新状态回调
        let footerRefreshState: Driver<RxMJRefreshFooterState>

        /// 数据源空时的点击事件回调
        let emptyDataSetViewTap: Driver<Void>
    }

    required init() {

        /// 头部刷新 (接收 + 回调)
        let beginHeaderRefresh = PublishSubject<Void>()
        /// 尾部刷新 (接收 + 回调)
        let beginFooterRefresh = PublishSubject<Void>()
        /// 头部刷新状态 (接收 + 回调)
        let headerRefreshState = PublishSubject<Bool>()
        /// 尾部刷新状态 (接收 + 回调)
        let footerRefreshState = PublishSubject<RxMJRefreshFooterState>()

        /// 点击占位
        let emptyDataSetViewTap = PublishSubject<Void>()

        refreshInput = RefreshInput(headerRefreshOb: beginHeaderRefresh.asObserver(),
                                    footerRefreshOb: beginFooterRefresh.asObserver(),
                                    headerRefreshStateOb: headerRefreshState.asObserver(),
                                    footerRefreshStateOb: footerRefreshState.asObserver(),
                                    emptyDataSetViewTapOb: emptyDataSetViewTap.asObserver())
        refreshOutput = RefreshOutput(headerRefreshing: beginHeaderRefresh.asDriverOnErrorJustComplete(),
                                      footerRefreshing: beginFooterRefresh.asDriverOnErrorJustComplete(),
                                      headerRefreshState: headerRefreshState.asDriverOnErrorJustComplete(),
                                      footerRefreshState: footerRefreshState.asDriverOnErrorJustComplete(),
                                      emptyDataSetViewTap: emptyDataSetViewTap.asDriverOnErrorJustComplete())
        super.init()
        transform()
    }

    func transform() {}
}

extension RefreshViewModel {

    public func footerState(_ isHasMore: Bool) -> RxMJRefreshFooterState {
        isHasMore ? .default : .noMoreData
    }
}
