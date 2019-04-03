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

        let headerRefresh: Driver<Void>
        let footerRefresh: Driver<Void>
    }

    struct Output {

        /// 数据源
        let items: Driver<[VideoCommentModel]>
        /// 刷新状态
        let endHeaderRefresh: Driver<Bool>
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
    }
}

extension UGCVideoCommentViewModel: ViewModelable {

    func transform(input: UGCVideoCommentViewModel.Input) -> UGCVideoCommentViewModel.Output {

        // 所有评论
        let elements = BehaviorRelay<[VideoCommentModel]>(value: [])

        // 加载最新评论
        let header = input.headerRefresh.flatMapLatest { [unowned self] in
            self.request(groupID: input.groupID, offset: 0)
        }

        // 加载更多评论
        let footer = input.footerRefresh
        .withLatestFrom(elements.asDriver()) { $1.count }
        .flatMapLatest { [unowned self] in
            self.request(groupID: input.groupID, offset: $0)
        }

        // 数据源绑定
        header.map { $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        footer.map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        // 头部刷新状态
        let endHeader = header.map { _ in false }
        // 尾部刷新状态
        let endFooter = Driver.merge(
            header.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty) },
            footer.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty) }
        )
        .startWith(.hidden)

        let output = Output(items: elements.asDriver(),
                            endHeaderRefresh: endHeader,
                            endFooterRefresh: endFooter)
        return output
    }
}

extension UGCVideoCommentViewModel {

    func request(groupID: String, offset: Int) -> Driver<Model<[VideoCommentModel]>> {

        return  VideoApi
                .ugcComment(groupID: groupID,
                            offset: offset)
                .request()
                .trackError(error)
                .mapObject(Model<[VideoCommentModel]>.self, atKeyPath: nil)
                .asDriverOnErrorJustComplete()
    }
}
