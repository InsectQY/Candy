//
//  UGCVideoActivityViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UGCVideoActivityViewModel: RefreshViewModel {

    struct Input {

        let headerRefresh: Driver<Void>
        let footerRefresh: Driver<Void>
    }

    struct Output {

        /// 数据源
        let items: Driver<[UGCVideoActivityAlbumList]>
        /// 刷新状态
        let endHeaderRefresh: Driver<Bool>
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
    }
}

extension UGCVideoActivityViewModel: ViewModelable {

    func transform(input: UGCVideoActivityViewModel.Input) -> UGCVideoActivityViewModel.Output {

        /// 活动数据
        let elements = BehaviorRelay<[UGCVideoActivityAlbumList]>(value: [])

        // 加载最新视频
        let header = input.headerRefresh
        .flatMapLatest { [unowned self] in
            self.request(offset: 0, userAction: .refresh)
        }

        // 加载更多视频
        let footer = input.footerRefresh
        .withLatestFrom(elements.asDriver()) { $1.count }
        .flatMapLatest { [unowned self] in
            self.request(offset: $0, userAction: .loadMore)
        }

        // 数据源
        header
        .map { $0.album_list }
        .drive(elements)
        .disposed(by: disposeBag)

        footer
        .map { elements.value + $0.album_list }
        .drive(elements)
        .disposed(by: disposeBag)

        // 头部刷新状态
        let endHeader = header.map { _ in false }
        // 尾部刷新状态
        let endFooter = Driver.merge(
            header.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.album_list.isEmpty)
            },
            footer.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.album_list.isEmpty)
            }
        )
        .startWith(.hidden)

        let output = Output(items: elements.asDriver(),
                            endHeaderRefresh: endHeader,
                            endFooterRefresh: endFooter)
        return output
    }
}

extension UGCVideoActivityViewModel {

    /// 加载活动数据
    func request(offset: Int, userAction: TTFrom) -> Driver<UGCVideoActivityListModel> {

        return  VideoApi.ugcActivity(offset: offset,
                                     userAction: userAction.rawValue)
                .request()
                .trackError(error)
                .mapObject(UGCVideoActivityListModel.self)
                .asDriverOnErrorJustComplete()
    }
}
