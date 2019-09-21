//
//   VideoListViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/5.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class VideoListViewModel: RefreshViewModel {

    struct Input {
        /// 视频分类
        let category: String
    }

    struct Output {

        /// 数据源
        let items: Driver<[NewsListModel]>
        /// 所有需要播放的视频 URL
        let videoURLs: Driver<[URL]>
    }
}

extension VideoListViewModel: ViewModelable {

    func transform(input: VideoListViewModel.Input) -> VideoListViewModel.Output {

        let elements = BehaviorRelay<[NewsListModel]>(value: [])

        // 所有需要播放的视频 URL
        let videoURLs = BehaviorRelay<[URL]>(value: [])

        // 加载最新视频
        let loadNew = refreshOutput
        .headerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 加载更多视频
        let loadMore = refreshOutput
        .footerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        // 数据源
        loadNew
        .drive(elements)
        .disposed(by: disposeBag)

        getUrls(loadNew)
        .drive(videoURLs)
        .disposed(by: disposeBag)

        loadMore
        .drive(elements.append)
        .disposed(by: disposeBag)

        getUrls(loadMore)
        .drive(videoURLs.append)
        .disposed(by: disposeBag)

        // success 下的刷新状态
        loadNew
        .mapTo(false)
        .drive(refreshInput.headerRefreshState)
        .disposed(by: disposeBag)

        Driver.merge(
            loadNew.map { _ in
                RxMJRefreshFooterState.default
            },
            loadMore.map { _ in
                RxMJRefreshFooterState.default
            }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshState)
        .disposed(by: disposeBag)

        let output = Output(items: elements.asDriver(),
                            videoURLs: videoURLs.asDriver())
        return output
    }

    private func getUrls(_ items: Driver<[NewsListModel]>) -> Driver<[URL]> {
        items
        .map {
            $0.map {
                URL(string: $0.content.video_play_info.video_list.video_1.mainURL)
            }
            .compactMap { $0 }
        }
    }
}

extension VideoListViewModel {

    /// 加载视频
    func request(category: String) -> Driver<[NewsListModel]> {

        VideoApi.list(category)
        .request()
        .mapObject([NewsListModel].self)
        .map {
            $0.filter {
                !($0.content.label).contains("广告")
            }
        }
        .trackActivity(loading)
        .trackError(refreshError)
        .asDriverOnErrorJustComplete()
    }
}
