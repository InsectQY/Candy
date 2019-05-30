//
//  ReplyCommentViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class ReplyCommentViewModel: RefreshViewModel {

    struct Input {
        let id: String
    }

    struct Output {
        /// 数据源
        let items: Driver<[ReplyComment]>
    }
}

extension ReplyCommentViewModel: ViewModelable {

    func transform(input: ReplyCommentViewModel.Input) -> ReplyCommentViewModel.Output {

        // 所有评论
        let elements = BehaviorRelay<[ReplyComment]>(value: [])

        let output = Output(items: elements.asDriver())

        // 加载最新评论
        let loadNew = refreshOutput
        .headerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(id: input.id,
                         offset: 0)
        }

        // 加载更多评论
        let loadMore = refreshOutput
        .footerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(id: input.id,
                         offset: elements.value.count)
        }

        // 数据源绑定
        loadNew
        .mapAt(\.data)
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .mapAt(\.data)
        .drive(elements.append)
        .disposed(by: disposeBag)

        // 头部刷新状态
        loadNew
        .mapTo(false)
        .drive(refreshInput.headerRefreshState)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            loadNew.map { [unowned self] in
                self.footerState($0.has_more,
                                 isEmpty: $0.data.isEmpty)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.has_more,
                                 isEmpty: $0.data.isEmpty)
            }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshState)
        .disposed(by: disposeBag)

        return output
    }
}

extension ReplyCommentViewModel {

    /// 加载某条评论的回复
    func request(id: String,
                 offset: Int) -> Driver<ReplyCommentModel> {

        return  VideoApi
                .replyComment(id: id,
                              offset: offset)
                .request()
                .mapObject(ReplyCommentModel.self)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
