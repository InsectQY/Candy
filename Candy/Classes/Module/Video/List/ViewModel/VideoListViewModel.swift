//
//   VideoListViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/5.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class VideoListViewModel: ViewModel {

    struct Input {

        /// 视频分类
        let category: String
        let headerRefresh: Driver<Void>
        let footerRefresh: Driver<Void>
    }

    struct Output {

        let endHeaderRefresh: Driver<Bool>
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
        /// 数据源
        let items: Driver<[NewsListModel]>
        /// 所有需要播放的视频 URL
        let videoURLs: Driver<[URL?]>
    }
}

extension VideoListViewModel: ViewModelable {

    func transform(input: VideoListViewModel.Input) -> VideoListViewModel.Output {

        let elements = BehaviorRelay<[NewsListModel]>(value: [])

        // 所有需要播放的视频 URL
        let videoURLs = elements.map {
            $0.map { URL(string: $0.news?.videoPlayInfo?.video_list.video_1.mainURL ?? "") }
        }.asDriverOnErrorJustComplete()

        // 加载最新视频
        let header = input.headerRefresh
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 加载更多视频
        let footer = input.footerRefresh
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 数据源
        header.drive(elements)
        .disposed(by: disposeBag)

        footer.map { elements.value + $0 }
        .drive(elements)
        .disposed(by: disposeBag)

        // 刷新状态
        let endHeader = header.map { _ in false }
        let endFooter = Driver.merge(header.map { _ in RxMJRefreshFooterState.default }, footer.map { _ in RxMJRefreshFooterState.default }).startWith(.hidden)

        let output = Output(endHeaderRefresh: endHeader,
                            endFooterRefresh: endFooter,
                            items: elements.asDriver(),
                            videoURLs: videoURLs)
        return output
    }
}

extension VideoListViewModel {

    /// 加载视频
    func request(category: String) -> Driver<[NewsListModel]> {

        return VideoApi.list(category)
        .request()
        .trackActivity(loading)
        .trackError(error)
        .mapObject([NewsListModel].self)
        .map { $0.filter { !($0.news?.label ?? "").contains("广告") } }
        .asDriver(onErrorJustReturn: [])
    }
}
