//
//  UserQAViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserQAViewModel: ViewModel {

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

        let new = self.request(category: input.category, visitedID: input.visitedID, offset: 0)

        // 下拉加载
        let footer = input.footerRefresh
        .withLatestFrom(offset.asDriver()) { $1 }
        .flatMapLatest { [unowned self] in
            self.request(category: input.category,
                         visitedID: input.visitedID,
                         offset: $0)
        }

        // 获取数据时绑定最新的 offset
        new.map { $0.offset }
        .drive(offset)
        .disposed(by: disposeBag)

        footer.map { $0.offset }
        .drive(offset)
        .disposed(by: disposeBag)

        // 绑定数据源
        new.map { $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        footer.map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        let endFooter = Driver.merge(
            new.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            },
            footer.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.data.isEmpty)
            }
            )
            .startWith(.hidden)

        let output = Output(items: elements.asDriver(),
                            endFooterRefresh: endFooter)
        return output
    }
}

extension UserQAViewModel {

    func request(category: String, visitedID: String, offset: Int) -> Driver<Model<[QAModel]>> {

        return VideoApi.profileType(category: category, visitedID: visitedID, offset: offset)
        .request()
        .asObservable()
        .mapObject(Model<[QAModel]>.self, atKeyPath: nil)
        .asDriverOnErrorJustComplete()
    }
}
