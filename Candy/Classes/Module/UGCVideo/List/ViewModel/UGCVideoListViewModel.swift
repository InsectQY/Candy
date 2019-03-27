//
//  UGCVideoListViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class UGCVideoListViewModel: ViewModel {

    struct Input {

        /// 视频分类
        let category: String
        /// 点击
        let selection: Driver<IndexPath>
        let headerRefresh: Driver<Void>
        let footerRefresh: Driver<Void>
    }

    struct Output {

        let endHeaderRefresh: Driver<Bool>
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
        let items: Driver<[UGCVideoListModel]>
    }
}

extension UGCVideoListViewModel: ViewModelable {

    func transform(input: UGCVideoListViewModel.Input) -> UGCVideoListViewModel.Output {

        let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])

        // 上拉刷新
        let header = input.headerRefresh
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 下拉加载
        let footer = input.footerRefresh
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 绑定数据源
        header.drive(elements)
        .disposed(by: disposeBag)

        footer.map { elements.value + $0 }
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
        let endHeader = header.map { _ in false }
        // 尾部状态
        let endFooter = Driver.merge(
            header.map { $0.isEmpty && elements.value.isEmpty ? RxMJRefreshFooterState.hidden : RxMJRefreshFooterState.default },
            footer.map { _ in RxMJRefreshFooterState.default }
            )
            .startWith(.hidden)

        let output = Output(endHeaderRefresh: endHeader,
                            endFooterRefresh: endFooter,
                            items: elements.asDriver())
        return output
    }
}

extension UGCVideoListViewModel {

    /// 加载小视频
    func request(category: String) -> Driver<[UGCVideoListModel]> {

        return VideoApi.ugcList(category)
        .request()
        .trackError(error)
        .mapObject([UGCVideoListModel].self)
        .asDriver(onErrorJustReturn: [])
    }
}
