//
//  UserUGCViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserUGCViewModel: ViewModel {

    struct Input {

        /// 请求类别
        let category: String
        /// 需要访问人的 ID
        let visitedID: String
        let footerRefresh: Driver<Void>
    }

    struct Output {

        /// 数据源
        let items: Driver<[UGCVideoListModel]>
        /// 刷新状态
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
    }
}

extension UserUGCViewModel: ViewModelable {

    func transform(input: UserUGCViewModel.Input) -> UserUGCViewModel.Output {

        let offset = BehaviorRelay<Int>(value: 0)
        let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])

        let new = request(category: input.category,
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
        new.map { $0.offset }
        .drive(offset)
        .disposed(by: disposeBag)

        footer.map { $0.offset }
        .drive(offset)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        let endFooter = Driver.merge(new.map { [unowned self] in self.footerState($0.has_more, isEmpty: $0.data.isEmpty) }, footer.map { [unowned self] in self.footerState($0.has_more, isEmpty: $0.data.isEmpty) }).startWith(.hidden)

        // 绑定数据源
        new.map { $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        footer.map { elements.value + $0.data }
        .drive(elements)
        .disposed(by: disposeBag)

        let output = Output(items: elements.asDriver(), endFooterRefresh: endFooter)
        return output
    }
}

extension UserUGCViewModel {

    func request(category: String, visitedID: String, offset: Int) -> Driver<Model<[UGCVideoListModel]>> {

        return VideoApi.profileType(category: category,
                                    visitedID: visitedID,
                                    offset: offset)
        .request()
        .asObservable()
        .mapObject(Model<[UGCVideoListModel]>.self, atKeyPath: nil)
        .asDriverOnErrorJustComplete()
    }
}
