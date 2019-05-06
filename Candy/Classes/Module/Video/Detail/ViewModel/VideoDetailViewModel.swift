//
//  VideoDetailViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class VideoDetailViewModel: RefreshViewModel {

    struct Input {

        let video: NewsModel?
        let selection: Driver<VideoDetailItem>
    }

    struct Output {

        /// 视频的真实播放地址
        let videoPlayInfo: Driver<VideoPlayInfo>
        /// 数据源
        let sections: Driver<[VideoDetailSection]>
    }

    override func bindState() {
        super.bindState()
        unified?.bindShowIndicator(with: loading)
    }
}

extension VideoDetailViewModel: ViewModelable {

    func transform(input: VideoDetailViewModel.Input) -> VideoDetailViewModel.Output {

        let itemID = input.video?.item_id ?? ""
        let groupID = input.video?.group_id ?? ""
        let videoID = input.video?.video_detail_info.video_id ?? ""

        // 所有评论
        let commentElements = BehaviorRelay<[VideoCommentModel]>(value: [])

        // 解析视频真实播放地址
        let realVideo = parsePlayInfo(videoID: videoID)

        // 加载相关新闻
        let relatedInfo = VideoApi.related(itemID: itemID,
                                           groupID: groupID)
        .request()
        .trackError(error)
        .mapObject(VideoDetailModel.self)
        .map {
            $0.related_video_toutiao.filter {
                !$0.show_tag.contains("广告")
            }
        }
        .asDriver(onErrorJustReturn: [])

        // 视频信息
        let infoSection = Driver
        .just(input.video)
        .filterNil()
        .map { VideoDetailSection.info([VideoDetailItem.info($0)]) }

        // 视频评论
        let commentSection = commentElements
        .asDriver()
        .map {
            VideoDetailSection.comment($0.map { VideoDetailItem.comment($0) })
        }

        // 相关视频
        let relatedSection = relatedInfo
        .asDriver()
        .map {
            VideoDetailSection.related($0.map { VideoDetailItem.related($0) })
        }

        // 数据源
        let sections = Driver.combineLatest(infoSection,
                                            commentSection,
                                            relatedSection) {
            (info: $0, comment: $1, related: $2)
        }
        .map { all -> [VideoDetailSection] in

            var sections: [VideoDetailSection] = []
            sections.append(all.info)
            sections.append(all.related)
            sections.append(all.comment)
            return sections
        }

        let output = Output(videoPlayInfo: realVideo,
                            sections: sections)

        guard let refresh = unified else { return output }

        // 加载最新评论
        let newComments = self.requestComment(itemID: itemID,
                                              groupID: groupID,
                                              offset: 0)

        // 加载更多评论
        let loadMoreComments = refresh.footer
        .asDriver()
        .withLatestFrom(commentElements.asDriver()) { $1.count }
        .flatMapLatest { [unowned self] in
            self.requestComment(itemID: itemID,
                                groupID: groupID,
                                offset: $0)
        }

        newComments
        .map { $0.data }
        .drive(commentElements)
        .disposed(by: disposeBag)

        loadMoreComments
        .map { commentElements.value + $0.data }
        .drive(commentElements)
        .disposed(by: disposeBag)

        // tableView 点击
        input.selection.drive(onNext: {

            switch $0 {
            case let .related(item):
                navigator.push(VideoURL.detail.path,
                               context: ["news": item,
                                          "seekTime": 0])
            default:
                break
            }
        })
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            newComments.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            },
            loadMoreComments.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            }
        )
        .startWith(.hidden)
        .drive(footerRefreshState)
        .disposed(by: disposeBag)

        bindErrorToRefreshFooterState(commentElements.value.isEmpty)

        return output
    }
}

extension VideoDetailViewModel {

    /// 解析视频真实播放地址
    func parsePlayInfo(videoID: String) -> Driver<VideoPlayInfo> {

        return  VideoApi.parsePlayInfo(videoID)
                .request()
                .mapObject(VideoPlayInfo.self)
                .trackActivity(loading)
                .trackError(error)
                .asDriverOnErrorJustComplete()
    }

    /// 加载评论
    func requestComment(itemID: String, groupID: String, offset: Int) -> Driver<Model<[VideoCommentModel]>> {

        return  VideoApi
                .comment(itemID: itemID,
                         groupID: groupID,
                         offset: offset)
                .request()
                .mapObject(Model<[VideoCommentModel]>.self, atKeyPath: nil)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
