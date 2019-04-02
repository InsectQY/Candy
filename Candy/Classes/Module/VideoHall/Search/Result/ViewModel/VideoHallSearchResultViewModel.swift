//
//  VideoHallSearchResultViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/9.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import RxURLNavigator

final class VideoHallSearchResultViewModel: ViewModel {

    struct Input {

        let keyword: String
        let selection: ControlEvent<VideoHallSearchResultList>
        let headerRefresh: Driver<Void>
        let footerRefresh: Driver<Void>
    }

    struct Output {

        /// 数据源
        let items: Driver<[VideoHallSearchResultList]>
        /// 刷新状态
        let endHeaderRefresh: Driver<Bool>
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
    }
}

extension VideoHallSearchResultViewModel: ViewModelable {

    func transform(input: VideoHallSearchResultViewModel.Input) -> VideoHallSearchResultViewModel.Output {

        let elements = BehaviorRelay<[VideoHallSearchResultList]>(value: [])

        // 加载最新视频
        let laodNew = input.headerRefresh
        .flatMapLatest { [unowned self] in
            self.request(offset: 0, key: input.keyword)
        }

        // 加载更多视频
        let loadMore = input.footerRefresh
        .withLatestFrom(elements.asDriver()) { $1 }
        .flatMapLatest { [unowned self] in
            self.request(offset: $0.count, key: input.keyword)
        }

        // 数据源
        laodNew
        .map { $0.data }
        .filterEmpty()
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        // 点击事件
        input.selection
        .flatMap { navigator.rx.push(VideoHallURL.detail.path, context: $0.display.album_content.first?.album_id ?? "") }
        .subscribe()
        .disposed(by: disposeBag)

        // 头部刷新状态
        let endHeader = laodNew.map { _ in false }
        // 尾部刷新状态
        let endFooter = Driver.merge(
            laodNew.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            }
            )
            .startWith(.hidden)

        let output = Output(items: elements.asDriver(),
                            endHeaderRefresh: endHeader,
                            endFooterRefresh: endFooter)
        return output
    }
}

extension VideoHallSearchResultViewModel {

    /// 搜索
    func request(offset: Int, key: String) -> Driver<VideoHallSearchResult> {

        return VideoHallApi.search(offset, key)
        .request()
        .trackActivity(loading)
        .trackError(error)
        .mapObject(VideoHallSearchResult.self, atKeyPath: nil)
        .asDriver(onErrorJustReturn: VideoHallSearchResult(data: [], has_more: false))
    }
}
