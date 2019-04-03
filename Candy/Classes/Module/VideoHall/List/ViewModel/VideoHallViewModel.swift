//
//  VideoHallViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import RxURLNavigator

final class VideoHallViewModel: RefreshViewModel {

    struct Input {

        let noConnectTap: Observable<Void>
        let searchTap: Observable<Void>
        let selection: ControlEvent<VideoHallList>
    }

    struct Output {

        /// 视频分类
        let categories: Driver<[CategoryList]>
        /// 该分类下的视频
        let items: Driver<[VideoHallList]>
    }

    let searchKey = PublishSubject<String>()
}

extension VideoHallViewModel: ViewModelable {

    func transform(input: VideoHallViewModel.Input) -> VideoHallViewModel.Output {

        /// 视频分类
        let categoryElements = BehaviorRelay<[CategoryList]>(value: [])
        /// 某个分类下的所有视频
        let videoElements = BehaviorRelay<[VideoHallList]>(value: [])

        // 获取视频分类
        requestCategory()
        .drive(categoryElements)
        .disposed(by: disposeBag)

        // 没有网络点击
        input.noConnectTap
        .asDriverOnErrorJustComplete()
        .flatMap { [unowned self] in
            self.requestCategory()
        }
        .drive(categoryElements)
        .disposed(by: disposeBag)

        let output = Output(categories: categoryElements.asDriver(),
                            items: videoElements.asDriver())

        guard let refresh = refresh else { return output }

        // 加载最新视频
        let laodNew = searchKey
        .asDriverOnErrorJustComplete()
        .distinctUntilChanged()
        .flatMapLatest { [unowned self] in
            self.requestVideo(offset: 0, searchKey: $0)
        }

        let moreParameters = Driver.combineLatest(
            videoElements.asDriver(),
            searchKey.asDriverOnErrorJustComplete()
        ) { (offset: $0.count, searchKey: $1) }

        // 加载更多视频
        let loadMore = refresh.footer
        .asDriver()
        .withLatestFrom(moreParameters)
        .flatMapLatest { [unowned self] in
            self.requestVideo(offset: $0.offset,
                              searchKey: $0.searchKey)
        }

        // 绑定数据源
        laodNew
        .map { $0.cell_list }
        .drive(videoElements)
        .disposed(by: disposeBag)

        loadMore
        .map { videoElements.value + $0.cell_list }
        .drive(videoElements)
        .disposed(by: disposeBag)

        // collectionView 点击
        input.selection
        .flatMap { navigator.rx.push(VideoHallURL.detail.path,
                                     context: $0.album.album_id) }
        .subscribe()
        .disposed(by: disposeBag)

        // 搜索点击
        input.searchTap
        .flatMap { navigator.rx.present(VideoHallURL.search.path,
                                        context: R.string.localizable.videoHallSearchPlaceholder(),
                                        wrap: NavigationController.self) }
        .subscribe()
        .disposed(by: disposeBag)

        // 尾部刷新状态
        Driver.merge(
            laodNew.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.cell_list.isEmpty)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.has_more, isEmpty: $0.cell_list.isEmpty)
            }
        )
        .startWith(.hidden)
        .drive(footerRefreshState)
        .disposed(by: disposeBag)

        return output
    }
}

extension VideoHallViewModel {

    /// 视频种类
    func requestCategory() -> Driver<[CategoryList]> {

        return  VideoHallApi.category
                .request()
                .mapObject(CategoryInfo.self, atKeyPath: "search_category_info")
                .map { $0.search_category_list }
                .trackActivity(loading)
                .trackError(error)
                .asDriverOnErrorJustComplete()
    }

    /// 某个分类下的视频
    func requestVideo(offset: Int, searchKey: String) -> Driver<VideoHallModel> {

        return  VideoHallApi
                .list(offset, searchKey)
                .request()
                .mapObject(VideoHallModel.self, atKeyPath: nil)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
