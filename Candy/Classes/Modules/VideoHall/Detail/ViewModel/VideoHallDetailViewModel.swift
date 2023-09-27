//
//  VideoHallDetailViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/20.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import Moya

final class VideoHallDetailViewModel: RefreshViewModel {

    struct Input {

        let albumID: String
        // 单集的 ID
        let episodeID = PublishSubject<String>()
    }

    struct Output {

        /// 所有集数
        let episodes: Driver<[CellList]>
        /// tableView 数据源
        let items: Driver<[VideoHallCellType]>
        /// 视频的真实播放地址
        let videoPlayInfo: Driver<VideoPlayInfo?>
    }
}

extension VideoHallDetailViewModel: ViewModelable {

    func transform(input: VideoHallDetailViewModel.Input) -> VideoHallDetailViewModel.Output {

        // 视频播放信息
        let videoPlayInfo = BehaviorRelay<VideoPlayInfo?>(value: nil)
        // tableView 数据源
        let elements = BehaviorRelay<[VideoHallCellType]>(value: [])

        // 单集的视频播放信息
        input.episodeID
        .asDriverOnErrorJustComplete()
        .flatMapLatest { [unowned self] in
            self.requestVideoInfo(albumID: input.albumID,
                                  episodeID: $0)
        }
        .flatMapLatest { [unowned self] in
            self.requestVideoPlayInfo(vid: $0.Episode.video_info.vid,
                                      pToken: $0.Episode.video_info.business_token,
                                      author: $0.Episode.video_info.auth_token)
        }
        .drive(videoPlayInfo)
        .disposed(by: disposeBag)

        // 历史记录
        var episodeID = ""
        if let history = HistoryManager.getPlayHistory(videoID: input.albumID) {
            episodeID = history.episodeID
        }

        // 视频详情信息
        let info = requestVideoInfo(albumID: input.albumID,
                                    episodeID: episodeID)

        // tableView 数据源
        info.drive(onNext: {

            var cellData: [VideoHallCellType] = []

            // 标题
            cellData.append(.title($0))
            // 影人
            if !$0.Album.actor_list.isEmpty {
                cellData.append(.role($0))
            }
            // 简介
            cellData.append(.intro($0))
            // 集数
            if $0.Album.isMultipleEpisode {
                cellData.append(.episode($0))
            }

            elements.accept(cellData)
        })
        .disposed(by: disposeBag)

        // 视频播放信息
        info.flatMapLatest { [unowned self] in
            self.requestVideoPlayInfo(vid: $0.Episode.video_info.vid,
                                      pToken: $0.Episode.video_info.business_token,
                                      author: $0.Episode.video_info.auth_token)
        }
        .drive(videoPlayInfo)
        .disposed(by: disposeBag)

        let output = Output(episodes: info.map(\.episodesInfo),
                            items: elements.asDriver(),
                            videoPlayInfo: videoPlayInfo.asDriver())
        return output
    }
}

extension VideoHallDetailViewModel {

    // 获取视频详情信息
    func requestVideoInfo(albumID: String,
                          episodeID: String) -> Driver<VideoHallDetailModel> {

        VideoHallApi
        .detail(albumID: albumID,
                episodeID: episodeID)
        .request()
        .mapObject(VideoHallDetailModel.self)
        .trackActivity(loading)
        .trackError(error)
        .asDriverOnErrorJustComplete()
    }

    // 获取视频播放信息
    func requestVideoPlayInfo(vid: String,
                              pToken: String,
                              author: String) -> Driver<VideoPlayInfo> {

        VideoApi
        .parseVideoHall(vid: vid,
                        pToken: pToken,
                        author: author)
        .request()
        .mapObject(TTModel<VideoPlayInfo>.self,
                   atKeyPath: "video_info")
        .debug()
        .filter(\.isSuccess)
        .map(\.data)
        .trackActivity(loading)
        .trackError(error)
        .asDriverOnErrorJustComplete()
    }
}
