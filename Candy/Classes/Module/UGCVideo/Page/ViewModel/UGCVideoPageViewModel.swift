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
        let noConnectTap: Observable<Void>
    }

    struct Output {

    }

    /// 分类数据
    let category = BehaviorRelay<[VideoCategory]>(value: [])
}

extension UGCVideoPageViewModel {

    @discardableResult
    func transform(input: UGCVideoPageViewModel.Input) -> UGCVideoPageViewModel.Output {

        input.noConnectTap
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

        return  VideoApi.ugcCategory.request()
                .trackActivity(loading)
                .mapObject(UGCVideoPageModel.self)
                .map { category -> [VideoCategory] in

                    var category = category.data
                    // 过滤这一组
                    category = category.filter { $0.name != "关注" }
                    return category
                }
                .asDriver(onErrorJustReturn: [VideoCategory(category: "hotsoon_video", name: "推荐")])
    }
}
