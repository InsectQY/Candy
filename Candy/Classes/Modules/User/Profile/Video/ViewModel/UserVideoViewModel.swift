//
//  UserVideoViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserVideoViewModel: RefreshViewModel {

    struct Input {
        /// 请求类别
        let category: String
        /// 需要访问人的 ID
        let visitedID: String
    }

    struct Output {
        /// 数据源
        let items: Driver<[NewsListModel]>
    }
}

extension UserVideoViewModel: ViewModelable {

    func transform(input: UserVideoViewModel.Input) -> UserVideoViewModel.Output {

        let offset = BehaviorRelay<Int>(value: 0)
        let elements = BehaviorRelay<[NewsListModel]>(value: [])

        let new = request(category: input.category,
                          visitedID: input.visitedID,
                          offset: 0)

        // 上拉加载更多
        let footer = refreshOutput
        .footerRefreshing
        .withLatestFrom(offset.asDriver()) { $1 }
        .flatMapLatest { [unowned self] in
            self.request(category: input.category,
                         visitedID: input.visitedID,
                         offset: $0)
        }

        // 获取数据时绑定最新的 offset
        new
        .map { $0.offset }
        .drive(offset)
        .disposed(by: disposeBag)

        footer
        .map { $0.offset }
        .drive(offset)
        .disposed(by: disposeBag)

        // 绑定数据源
        new
        .map { $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        footer
        .map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            new.map { [unowned self] in
                self.footerState($0.has_more,
                                 isEmpty: $0.data.isEmpty) },
            footer.map { [unowned self] in
                self.footerState($0.has_more,
                                 isEmpty: $0.data.isEmpty) }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshState)
        .disposed(by: disposeBag)

        let output = Output(items: elements.asDriver())

        return output
    }
}

extension UserVideoViewModel {

    func request(category: String,
                 visitedID: String,
                 offset: Int) -> Driver<Model<[NewsListModel]>> {

        return  VideoApi
                .profileType(category: category,
                             visitedID: visitedID,
                             offset: offset)
                .request()
                .mapObject(Model<[NewsListModel]>.self, atKeyPath: nil)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
