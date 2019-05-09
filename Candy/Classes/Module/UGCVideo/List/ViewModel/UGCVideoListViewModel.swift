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

        /// 所有视频
        let items: Driver<[UGCVideoListModel]>
        /// 所有需要播放的视频 URL
        let videoURLs: Driver<[URL?]>
    }
}

extension UGCVideoListViewModel: ViewModelable {

    func transform(input: UGCVideoListViewModel.Input) -> UGCVideoListViewModel.Output {

        let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])

        // 所有需要播放的视频 URL
        let videoURLs = elements
        .map {
            $0.map {
                URL(string: $0.video?.raw_data.video.play_addr.url_list.first ?? "")
            }
        }
        .asDriverOnErrorJustComplete()

        let output = Output(items: elements.asDriver(),
                            videoURLs: videoURLs)

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
        .withLatestFrom(elements.asDriver()) {
            (indexPath: $0, items: $1)
        }
        .map {
            ["category": input.category,
                    "items": $0.items,
                    "indexPath": $0.indexPath]
        }
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
