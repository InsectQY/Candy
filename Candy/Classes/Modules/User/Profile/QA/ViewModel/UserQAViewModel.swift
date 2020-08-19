//
//  UserQAViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserQAViewModel: RefreshViewModel {

    struct Input {

        /// 请求类别
        let category: String
        /// 需要访问人的 ID
        let visitedID: String
        let footerRefresh: Driver<Void>
    }

    struct Output {
        /// 数据源
        let items: Driver<[QAModel]>
        /// 刷新状态
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
    }
}

extension UserQAViewModel: ViewModelable {

    func transform(input: UserQAViewModel.Input) -> UserQAViewModel.Output {

        let offset = BehaviorRelay<Int>(value: 0)
        let elements = BehaviorRelay<[QAModel]>(value: [])

        let new = self.request(category: input.category,
                               visitedID: input.visitedID,
                               offset: 0)

        // 下拉加载
        let footer = input.footerRefresh
        .withLatestFrom(offset.asDriver()) { $1 }
        .flatMapLatest { [unowned self] in
            self.request(category: input.category,
                         visitedID: input.visitedID,
                         offset: $0)
        }

        // 获取数据时绑定最新的 offset
        new.map(\.offset)
        .drive(offset)
        .disposed(by: disposeBag)

        footer.map(\.offset)
        .drive(offset)
        .disposed(by: disposeBag)

        // 绑定数据源
        new
        .map(\.data)
        .drive(elements)
        .disposed(by: disposeBag)

        footer
        .map(\.data)
        .drive(elements.append)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        let endFooter = Driver.merge(
            new.map { [unowned self] in
                self.footerState($0.has_more)
            },
            footer.map { [unowned self] in
                self.footerState($0.has_more)
            }
        )
        .startWith(.hidden)

        let output = Output(items: elements.asDriver(),
                            endFooterRefresh: endFooter)
        return output
    }
}

extension UserQAViewModel {

    func request(category: String,
                 visitedID: String,
                 offset: Int) -> Driver<TTModel<[QAModel]>> {

        VideoApi
        .profileType(category: category,
                     visitedID: visitedID,
                     offset: offset)
        .request()
        .mapObject(TTModel<[QAModel]>.self)
        .trackActivity(loading)
        .trackError(error)
        .asDriverOnErrorJustComplete()
    }
}
