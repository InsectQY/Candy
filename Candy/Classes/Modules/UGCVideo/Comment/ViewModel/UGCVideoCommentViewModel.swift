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
        let id: String
    }

    struct Output {
        /// 数据源
        let items: Driver<[UGCVideoCommentModel]>
    }
}

extension UGCVideoCommentViewModel: ViewModelable {

    func transform(input: UGCVideoCommentViewModel.Input) -> UGCVideoCommentViewModel.Output {

        // 所有评论
        let elements = BehaviorRelay<[UGCVideoCommentModel]>(value: [])

        // 加载最新评论
        let loadNew = refreshOutput
        .headerRefreshing
        .flatMapLatest { [unowned self] in
            self.request(id: input.id)
        }

        // 数据源绑定
        loadNew
        .drive(elements)
        .disposed(by: disposeBag)

        // 头部刷新状态
        loadNew
        .mapTo(false)
        .drive(refreshInput.headerRefreshStateOb)
        .disposed(by: disposeBag)

        let output = Output(items: elements.asDriver())

        return output
    }
}

extension UGCVideoCommentViewModel {

    func request(id: String) -> Driver<[UGCVideoCommentModel]> {
        MacoooApi
        .comment(id)
        .request()
        .mapObject([UGCVideoCommentModel].self)
        .trackActivity(loading)
        .trackError(refreshError)
        .asDriverOnErrorJustComplete()
    }
}
