//
//  VideoHallViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import RxURLNavigator

final class VideoHallViewModel: RefreshViewModel, NestedViewModelable {

    let input: Input
    let output: Output

    struct Input {

        let searchTapOb: AnyObserver<Void>
        let selectionOb: AnyObserver<VideoHallList>
        let searchKeyOb: AnyObserver<String>
    }

    struct Output {

        /// 视频分类
        let categories: Driver<[CategoryList]>
        /// 该分类下的视频
        let items: Driver<[VideoHallList]>
        /// 筛选 view 高度
        let filterViewHeight: Driver<CGFloat>
    }

    /// 搜索点击
    private let searchTap = PublishSubject<Void>()
    /// 点击了某个视频
    private let selection = PublishSubject<VideoHallList>()
    /// 选择了新的视频种类
    private let searchKey = PublishSubject<String>()

    /// 视频分类
    private let categoryElements = BehaviorRelay<[CategoryList]>(value: [])
    /// 某个分类下的所有视频
    private let videoElements = BehaviorRelay<[VideoHallList]>(value: [])
    /// 筛选 view 高度
    private let filterViewHeight = BehaviorRelay<CGFloat>(value: 0)

    required init() {

        input = Input(searchTapOb: searchTap.asObserver(),
                      selectionOb: selection.asObserver(),
                      searchKeyOb: searchKey.asObserver())
        output = Output(categories: categoryElements.asDriver(),
                        items: videoElements.asDriver(),
                        filterViewHeight: filterViewHeight.asDriver())
        super.init()
    }

    override func transform() {
        super.transform()

        // 获取视频分类
        requestCategory()
        .drive(categoryElements)
        .disposed(by: disposeBag)

        // filterView 的高度
        categoryElements
        .map {
            FilterCell.cellHeight * CGFloat($0.count) + FilterCell.categoryViewY
        }
        .bind(to: filterViewHeight)
        .disposed(by: disposeBag)

        // 没有网络点击
        refreshOutput.emptyDataSetViewTap
        .flatMap { [unowned self] in
            self.requestCategory()
        }
        .drive(categoryElements)
        .disposed(by: disposeBag)

        // 加载最新视频
        let loadNew = searchKey
        .asDriverOnErrorJustComplete()
        .distinctUntilChanged()
        .flatMapLatest { [unowned self] in
            self.requestVideo(offset: 0,
                              searchKey: $0)
        }

        let moreParameters = Driver.combineLatest(
            videoElements.asDriver(),
            searchKey.asDriverOnErrorJustComplete()
        ) {
            (offset: $0.count, searchKey: $1)
        }

        // 加载更多视频
        let loadMore = refreshOutput
        .footerRefreshing
        .withLatestFrom(moreParameters)
        .flatMapLatest { [unowned self] in
            self.requestVideo(offset: $0.offset,
                              searchKey: $0.searchKey)
        }

        // 绑定数据源
        loadNew
        .map(\.CellList)
        .drive(videoElements)
        .disposed(by: disposeBag)

        loadMore
        .map(\.CellList)
        .drive(videoElements.append)
        .disposed(by: disposeBag)

        // collectionView 点击
        selection
        .flatMap {
            navigator.rx.push(VideoHallURL.detail.path,
                              context: $0.album.album_id)
        }
        .subscribe()
        .disposed(by: disposeBag)

        // 搜索点击
        searchTap
        .flatMap {
            navigator.rx.present(VideoHallURL.search.path,
                                 context: R.string.localizable.videoHallSearchPlaceholder(),
                                 wrap: NavigationController.self)
        }
        .subscribe()
        .disposed(by: disposeBag)

        // 尾部状态
        Driver.merge(
            loadNew.map { [unowned self] in
                self.footerState($0.IndexResponse.has_more)
            },
            loadMore.map { [unowned self] in
                self.footerState($0.IndexResponse.has_more)
            }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshStateOb)
        .disposed(by: disposeBag)
    }
}

extension VideoHallViewModel {

    /// 视频种类
    func requestCategory() -> Driver<[CategoryList]> {

        VideoHallApi.category
        .request()
        .mapObject([CategoryList].self,
                   atKeyPath: "search_category_info.search_category_list")
        .trackActivity(loading)
        .trackError(error)
        .asDriverOnErrorJustComplete()
    }

    /// 某个分类下的视频
    func requestVideo(offset: Int, searchKey: String) -> Driver<VideoHallModel> {

        VideoHallApi
        .list(offset,
              searchKey)
        .request()
        .mapObject(VideoHallModel.self)
        .trackActivity(loading)
        .trackError(refreshError)
        .asDriverOnErrorJustComplete()
    }
}
