//
//  UGCVideoDetailViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/17.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class UGCVideoDetailViewModel: ViewModel {

    struct Input {

        /// 视频分类
        let category: String
        /// 已经加载的视频
        let videoDatas: [UGCVideoListModel]
        /// 加载更多
        let loadMore = PublishSubject<Void>()
    }

    struct Output {
        /// 所有视频
        let items: Driver<[UGCVideoListModel]>
        /// 所有需要播放的视频 URL
        let videoURLs: Driver<[URL?]>
    }
}

extension UGCVideoDetailViewModel: ViewModelable {

    func transform(input: UGCVideoDetailViewModel.Input) -> UGCVideoDetailViewModel.Output {

        let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])

        // 上个界面已经加载的视频
        elements.accept(input.videoDatas)

        // 所有需要播放的视频 URL
        let videoURLs = elements
//        .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .map {
            $0.map {
                URL(string: $0.video?.raw_data.video.play_addr.url_list.first ?? "")
            }
        }
        .asDriverOnErrorJustComplete()

        // 加载更多视频
        let more = input.loadMore
        .asDriverOnErrorJustComplete()
        .flatMapLatest { [unowned self] in
            self.request(category: input.category)
        }

        more
        .map { elements.value + $0 }
        .drive(elements)
        .disposed(by: disposeBag)

        let output = Output(items: elements.asDriver(),
                            videoURLs: videoURLs)
        return output
    }
}

extension UGCVideoDetailViewModel {

    func request(category: String) -> Driver<[UGCVideoListModel]> {

        return  VideoApi
                .list(category)
                .request()
                .mapObject([UGCVideoListModel].self)
                .trackActivity(loading)
                .trackError(error)
                .asDriver(onErrorJustReturn: [])
    }
}
