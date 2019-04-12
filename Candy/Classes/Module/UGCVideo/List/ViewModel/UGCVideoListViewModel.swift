//
//  UGCVideoListViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class UGCVideoListViewModel: RefreshViewModel {

    struct Input {

        /// 视频分类
        let category: String
        /// 点击
        let selection: Driver<IndexPath>
    }

    struct Output {

        let items: Driver<[UGCVideoListModel]>
    }
}

extension UGCVideoListViewModel: ViewModelable {

    func transform(input: UGCVideoListViewModel.Input) -> UGCVideoListViewModel.Output {

        let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])

        let output = Output(items: elements.asDriver())

        guard let refresh = unified else { return output }
        // 下拉刷新
        let loadNew = refresh.header
        .asDriver()
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 上拉加载
        let loadMore = refresh.footer
        .asDriver()
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 绑定数据源
        loadNew
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .map { elements.value + $0 }
        .drive(elements)
        .disposed(by: disposeBag)

        // collectionView 点击事件
        input.selection
        .withLatestFrom(elements.asDriver()) { (indexPath: $0, items: $1) }
        .map { ["category": input.category,
                    "items": $0.items,
                    "indexPath": $0.indexPath] }
        .drive(onNext: {
            navigator.present(UGCURL.detail.path, context: $0)
        })
        .disposed(by: disposeBag)

        // 头部状态
        loadNew.map { _ in false }
        .drive(headerRefreshState)
        .disposed(by: disposeBag)

        // 尾部状态
        Driver.merge(
            loadNew.map { $0.isEmpty && elements.value.isEmpty ? RxMJRefreshFooterState.hidden : RxMJRefreshFooterState.default },
            loadMore.map { _ in RxMJRefreshFooterState.default }
        )
        .startWith(.hidden)
        .drive(footerRefreshState)
        .disposed(by: disposeBag)

        // error 下的刷新状态
        bindErrorToRefreshFooterState(elements.value.isEmpty)

        return output
    }
}

extension UGCVideoListViewModel {

    /// 加载小视频
    func request(category: String) -> Driver<[UGCVideoListModel]> {

        return  VideoApi
                .ugcList(category)
                .request()
                .mapObject([UGCVideoListModel].self)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
