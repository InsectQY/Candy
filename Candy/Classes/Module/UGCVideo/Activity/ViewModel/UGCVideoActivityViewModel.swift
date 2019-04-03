//
//  UGCVideoActivityViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UGCVideoActivityViewModel: RefreshViewModel {

    struct Input {}

    struct Output {
        /// 数据源
        let items: Driver<[UGCVideoActivityAlbumList]>
    }
}

extension UGCVideoActivityViewModel: ViewModelable {

    func transform(input: UGCVideoActivityViewModel.Input) -> UGCVideoActivityViewModel.Output {

        /// 活动数据
        let elements = BehaviorRelay<[UGCVideoActivityAlbumList]>(value: [])

        let output = Output(items: elements.asDriver())

        guard let refresh = refresh else { return output }
        // 加载最新视频
        let loadNew = refresh.header
        .asDriver()
        .flatMapLatest { [unowned self] in
            self.request(offset: 0, userAction: .refresh)
        }

        // 加载更多视频
        let loadMore = refresh.footer
        .asDriver()
        .withLatestFrom(elements.asDriver()) { $1.count }
        .flatMapLatest { [unowned self] in
            self.request(offset: $0, userAction: .loadMore)
        }

        // 数据源
        loadNew
        .map { $0.album_list }
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .map { elements.value + $0.album_list }
        .drive(elements)
        .disposed(by: disposeBag)

        // 头部刷新状态
        loadNew.map { _ in false }
        .drive(headerRefreshState)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            loadNew.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.album_list.isEmpty)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.album_list.isEmpty)
            }
        )
        .startWith(.hidden)
        .drive(footerRefreshState)
        .disposed(by: disposeBag)

        return output
    }
}

extension UGCVideoActivityViewModel {

    /// 加载活动数据
    func request(offset: Int, userAction: TTFrom) -> Driver<UGCVideoActivityListModel> {

        return  VideoApi
                .ugcActivity(offset: offset,
                             userAction: userAction.rawValue)
                .request()
                .mapObject(UGCVideoActivityListModel.self)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
