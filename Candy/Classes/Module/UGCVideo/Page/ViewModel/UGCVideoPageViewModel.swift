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

    }

    struct Output {

    }

    /// 分类数据
    let category = BehaviorRelay<[VideoCategory]>(value: [])
}

extension UGCVideoPageViewModel {

    @discardableResult
    func transform(input: UGCVideoPageViewModel.Input) -> UGCVideoPageViewModel.Output {

        VideoApi.ugcCategory.request()
        .trackActivity(loading)
        .mapObject(UGCVideoPageModel.self)
        .map { category -> [VideoCategory] in

            var category = category.data
            category.removeFirst()
            return category
        }.asDriver(onErrorJustReturn: [])
        .drive(category)
        .disposed(by: disposeBag)

        return Output()
    }
}
