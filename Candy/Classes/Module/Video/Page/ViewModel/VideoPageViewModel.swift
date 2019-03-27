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

    }

    struct Output {

    }

    /// 分类数据
    let category = BehaviorRelay<[VideoCategory]>(value: [])
}

extension VideoPageViewModel: ViewModelable {

    @discardableResult
    func transform(input: VideoPageViewModel.Input) -> VideoPageViewModel.Output {

        request()
        .drive(category)
        .disposed(by: disposeBag)

        return Output()
    }
}

extension VideoPageViewModel {

    func request() -> Driver<[VideoCategory]> {

        let dafaultCategory = VideoCategory(category: "video", name: "推荐")
        return VideoApi.category
        .request()
        .trackActivity(loading)
        .trackError(error)
        .mapObject([VideoCategory].self)
        .map { category -> [VideoCategory] in

            var category = category
            // 过滤这三组
            category = category.filter { $0.name != "直播" && $0.name != "考得好" && $0.name != "关注" }
            category.insert(dafaultCategory, at: 0)
            return category
        }
        .asDriver(onErrorJustReturn: [dafaultCategory])
    }
}
