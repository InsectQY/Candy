//
//  UGCVideoPageViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class UGCVideoPageViewModel: ViewModel {
    struct Input {
        let emptyDataSetViewTap: Observable<Void>
    }

    struct Output {}

    /// 分类数据
    let category = BehaviorRelay<[VideoCategory]>(value: [])
}

extension UGCVideoPageViewModel {
    @discardableResult
    func transform(input: UGCVideoPageViewModel.Input) -> UGCVideoPageViewModel.Output {
        input.emptyDataSetViewTap
            .asDriverOnErrorJustComplete()
            .flatMap { [unowned self] in
                self.request()
            }
            .drive(category)
            .disposed(by: disposeBag)

        // 获取视频分类
        request()
            .drive(category)
            .disposed(by: disposeBag)

        return Output()
    }
}

extension UGCVideoPageViewModel {
    func request() -> Driver<[VideoCategory]> {
        MacoooApi
            .category
            .request()
            .mapObject(UGCVideoPageModel.self, atKeyPath: "confs")
            .map(\.channels)
            .asObservable()
            .trackActivity(loading)
            .asDriver(onErrorJustReturn: [])
    }
}
