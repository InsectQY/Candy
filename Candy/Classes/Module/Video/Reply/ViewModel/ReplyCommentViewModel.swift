//
//  ReplyCommentViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class ReplyCommentViewModel: ViewModel {

    struct Input {

        let id: String

        let headerRefresh: Driver<Void>
        let footerRefresh: Driver<Void>
    }

    struct Output {

        /// 数据源
        let items: Driver<[ReplyComment]>
        /// 刷新状态
        let endHeaderRefresh: Driver<Bool>
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
    }
}

extension ReplyCommentViewModel: ViewModelable {

    func transform(input: ReplyCommentViewModel.Input) -> ReplyCommentViewModel.Output {

        // 所有评论
        let elements = BehaviorRelay<[ReplyComment]>(value: [])

        // 加载最新评论
        let header = input.headerRefresh.flatMapLatest { [unowned self] in
            self.request(id: input.id, offset: 0)
        }

        // 加载更多评论
        let footer = input.footerRefresh
        .withLatestFrom(elements.asDriver()) { $1.count }
        .flatMapLatest { [unowned self] in
            self.request(id: input.id, offset: $0)
        }

        // 数据源绑定
        header
        .map { $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        footer
        .map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        // 头部刷新状态
        let endHeader = header.map { _ in false }
        // 尾部刷新状态
        let endFooter = Driver.merge(
            header.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            },
            footer.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            }
        )
        .startWith(.hidden)
        
        let output = Output(items: elements.asDriver(),
                            endHeaderRefresh: endHeader,
                            endFooterRefresh: endFooter)
        return output
    }
}

extension ReplyCommentViewModel {

    /// 加载某条评论的回复
    func request(id: String, offset: Int) -> Driver<ReplyCommentModel> {

        return  VideoApi.replyComment(id: id, offset: offset)
                .request()
                .trackError(error)
                .mapObject(ReplyCommentModel.self)
                .asDriverOnErrorJustComplete()
    }
}
