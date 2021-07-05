//
//  VideoPageViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/5.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class VideoPageViewModel: ViewModel {

    struct Input {
        let noConnectTap: Observable<Void>
    }

    struct Output {}

    /// 分类数据
    let category = BehaviorRelay<[VideoCategory]>(value: [])
}

extension VideoPageViewModel: ViewModelable {

    @discardableResult
    func transform(input: VideoPageViewModel.Input) -> VideoPageViewModel.Output {

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

extension VideoPageViewModel {

    func request() -> Driver<[VideoCategory]> {

        let defaultCategory = VideoCategory(category: "video",
                                            name: "推荐")
        return VideoApi.category
        .request()
        .mapTTModelData([VideoCategory].self)
        .map { category -> [VideoCategory] in

            var category = category
            // 过滤这三组
            category = category.filter {
                !(["直播", "考得好", "关注"].contains($0.name))
            }
            category.insert(defaultCategory, at: 0)
            return category
        }
        .trackActivity(loading)
        .trackError(error)
        .asDriver(onErrorJustReturn: [defaultCategory])
    }
}
