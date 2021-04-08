//
//  UGCVideoListViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

final class UGCVideoListViewModel: RefreshViewModel, NestedViewModelable {

    let input: Input
    let output: Output

    struct Input {
        /// 点击
        let selectionOb: AnyObserver<IndexPath>
    }

    struct Output {

        /// 所有视频
        let items: Driver<[ShortVideoItem]>
        /// 所有需要播放视频的 URL
        let videoURLs: Driver<[URL]>
        /// 已经选中的视频
        let indexPath: Driver<IndexPath>
    }

    /// 点击
    private let selection = PublishSubject<IndexPath>()

    // 所有视频
    private let elements = BehaviorRelay<[ShortVideoItem]>(value: [])
    // 所有需要播放的视频 URL
    private let videoURLs = BehaviorRelay<[URL]>(value: [])
    // 当前选中的
    private let indexPath = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))

    required init() {

        input = Input(selectionOb: selection.asObserver())
        output = Output(items: elements.asDriver(),
                        videoURLs: videoURLs.asDriver(),
                        indexPath: indexPath.asDriver())
        super.init()
    }

    override func transform() {
        super.transform()

        // 下拉刷新
        let loadNew = refresh(refreshOutput.headerRefreshing)

        // 上拉加载
        let loadMore = refresh(refreshOutput.footerRefreshing)

        // 绑定数据源
        loadNew
        .drive(elements)
        .disposed(by: disposeBag)

        loadMore
        .drive(elements.append)
        .disposed(by: disposeBag)

        // 解析视频播放地址
        getUrls(loadNew)
        .drive(videoURLs)
        .disposed(by: disposeBag)

        getUrls(loadMore)
        .drive(videoURLs.append)
        .disposed(by: disposeBag)

        // collectionView 点击事件
        selection
        .asDriverOnErrorJustComplete()
        .drive(indexPath)
        .disposed(by: disposeBag)

        // 点击跳转
        selection
        .flatMap { [weak self] _ in
            navigator.rx.present(UGCURL.detail.path,
                                 context: self,
                                 wrap: NavigationController.self)
        }
        .subscribe()
        .disposed(by: disposeBag)

        // 头部状态
        loadNew
        .mapTo(false)
        .drive(refreshInput.headerRefreshStateOb)
        .disposed(by: disposeBag)

        // 尾部状态
        Driver.merge(
            loadNew.map { _ in
                RxMJRefreshFooterState.default
            },
            loadMore.map { _ in
                RxMJRefreshFooterState.default
            }
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshStateOb)
        .disposed(by: disposeBag)
    }

    private func refresh(_ refreshing: Driver<Void>) -> Driver<[ShortVideoItem]> {

        refreshing
        .flatMapLatest { [unowned self] in
            self.request()
        }
    }

    private func getUrls(_ items: Driver<[ShortVideoItem]>) -> Driver<[URL]> {
        items
        .map {
            $0.compactMap(\.videoInfo.videoUrls[0].playURL)
        }
    }
}

extension UGCVideoListViewModel {

    /// 加载小视频
    func request() -> Driver<[ShortVideoItem]> {

        ShortVideoApi
        .list
        .request()
        .mapKKModelData(ShortVideoModel.self)
        .map(\.items)
        .trackError(refreshError)
        .trackActivity(loading)
        .asDriverOnErrorJustComplete()
    }
}
