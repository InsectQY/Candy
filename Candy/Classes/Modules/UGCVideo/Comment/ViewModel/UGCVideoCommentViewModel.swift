//
//  UGCVideoCommentViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/28.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import CleanJSON

final class UGCVideoCommentViewModel: RefreshViewModel {

    struct Input {
        let id: String
    }

    struct Output {
        /// 数据源
        let items: Driver<[ShortVideoCommentItem]>
    }
}

extension UGCVideoCommentViewModel: ViewModelable {

    func transform(input: UGCVideoCommentViewModel.Input) -> UGCVideoCommentViewModel.Output {

        // 所有评论
        let elements = BehaviorRelay<[ShortVideoCommentItem]>(value: [])
        // 下一页角标
        let nextCursor = BehaviorRelay<String>(value: "0")

        // 加载最新评论
        let loadNew = refreshOutput
        .headerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(id: input.id,
                         offset: "0")
        }
        // 加载更多评论
        let loadMore = refreshOutput
        .footerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(id: input.id,
                         offset: nextCursor.value)
        }

        // 下一页角标
        loadNew
        .map(\.nextCursor)
        .drive(nextCursor)
        .disposed(by: disposeBag)

        loadMore
        .map(\.nextCursor)
        .drive(nextCursor)
        .disposed(by: disposeBag)

        // 数据源绑定
        loadNew
        .map(\.comments)
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .map(\.comments)
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
                self.footerState($0.hasMore)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.hasMore)
            }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshState)
        .disposed(by: disposeBag)

        let output = Output(items: elements.asDriver())

        return output
    }
}

extension UGCVideoCommentViewModel {

    func request(id: String, offset: String) -> Driver<ShortVideoComment> {
        ShortVideoApi
        .comment(id: id, cursor: offset)
        .request()
        .mapKKComment()
        .trackActivity(loading)
        .trackError(refreshError)
        .asDriverOnErrorJustComplete()
    }
}
