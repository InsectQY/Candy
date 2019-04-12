//
//  UGCVideoCommentViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/28.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class UGCVideoCommentViewModel: RefreshViewModel {

    struct Input {

        let groupID: String
    }

    struct Output {

        /// 数据源
        let items: Driver<[VideoCommentModel]>
    }
}

extension UGCVideoCommentViewModel: ViewModelable {

    func transform(input: UGCVideoCommentViewModel.Input) -> UGCVideoCommentViewModel.Output {

        // 所有评论
        let elements = BehaviorRelay<[VideoCommentModel]>(value: [])

        let output = Output(items: elements.asDriver())

        guard let refresh = unified else { return output }

        // 加载最新评论
        let loadNew = refresh.header
        .asDriver()
        .flatMapLatest { [unowned self] in
            self.request(groupID: input.groupID, offset: 0)
        }

        // 加载更多评论
        let loadMore = refresh.footer
        .asDriver()
        .withLatestFrom(elements.asDriver()) { $1.count }
        .flatMapLatest { [unowned self] in
            self.request(groupID: input.groupID, offset: $0)
        }

        // 数据源绑定
        loadNew
        .map { $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        // 头部刷新状态
        loadNew
        .map { _ in false }
        .drive(headerRefreshState)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            loadNew.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            }
        )
        .startWith(.hidden)
        .drive(footerRefreshState)
        .disposed(by: disposeBag)

        bindErrorToRefreshFooterState(elements.value.isEmpty)

        return output
    }
}

extension UGCVideoCommentViewModel {

    func request(groupID: String, offset: Int) -> Driver<Model<[VideoCommentModel]>> {

        return  VideoApi
                .ugcComment(groupID: groupID,
                            offset: offset)
                .request()
                .mapObject(Model<[VideoCommentModel]>.self, atKeyPath: nil)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
