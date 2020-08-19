//
//  UserUGCViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserUGCViewModel: RefreshViewModel {

    struct Input {

        /// 请求类别
        let category: String
        /// 需要访问人的 ID
        let visitedID: String
    }

    struct Output {
        /// 数据源
        let items: Driver<[UGCVideoListModel]>
    }
}

extension UserUGCViewModel: ViewModelable {

    func transform(input: UserUGCViewModel.Input) -> UserUGCViewModel.Output {

        let offset = BehaviorRelay<Int>(value: 0)
        let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])

        let output = Output(items: elements.asDriver())

        let new = request(category: input.category,
                          visitedID: input.visitedID,
                          offset: 0)

        // 上拉加载更多
        let loadMore = refreshOutput
        .footerRefreshing
        .withLatestFrom(offset.asDriver()) { $1 }
        .flatMapLatest { [unowned self] in
            self.request(category: input.category,
                         visitedID: input.visitedID,
                         offset: $0)
        }

        // 获取数据时绑定最新的 offset
        new
        .map(\.offset)
        .drive(offset)
        .disposed(by: disposeBag)

        loadMore
        .map(\.offset)
        .drive(offset)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            new.map { [unowned self] in
                self.footerState($0.has_more)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.has_more)
            }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshState)
        .disposed(by: disposeBag)

        // 绑定数据源
        new
        .map(\.data)
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .map(\.data)
        .drive(elements.append)
        .disposed(by: disposeBag)

        return output
    }
}

extension UserUGCViewModel {

    func request(category: String,
                 visitedID: String,
                 offset: Int) -> Driver<TTModel<[UGCVideoListModel]>> {

        VideoApi
        .profileType(category: category,
                     visitedID: visitedID,
                     offset: offset)
        .request()
        .mapObject(TTModel<[UGCVideoListModel]>.self)
        .trackActivity(loading)
        .trackError(refreshError)
        .asDriverOnErrorJustComplete()
    }
}
