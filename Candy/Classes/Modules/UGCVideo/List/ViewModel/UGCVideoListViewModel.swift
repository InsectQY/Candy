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

        /// 视频分类
        let category: AnyObserver<String>
        /// 点击
        let selection: AnyObserver<IndexPath>
    }

    struct Output {

        /// 所有视频
        let items: Driver<[UGCVideoListModel]>
        /// 所有需要播放视频的 URL
        let videoURLs: Driver<[URL]>
        /// 已经选中的视频
        let indexPath: Driver<IndexPath>
    }

    /// 视频分类
    private let category = PublishSubject<String>()
    /// 点击
    private let selection = PublishSubject<IndexPath>()

    // 所有视频
    private let elements = BehaviorRelay<[UGCVideoListModel]>(value: [])
    // 所有需要播放的视频 URL
    private let videoURLs = BehaviorRelay<[URL]>(value: [])
    // 当前选中的
    private let indexPath = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))

    required init() {

        input = Input(category: category.asObserver(),
                      selection: selection.asObserver())
        output = Output(items: elements.asDriver(),
                        videoURLs: videoURLs.asDriver(),
                        indexPath: indexPath.asDriver())
        super.init()
    }

    override func bindState() {
        super.bindState()

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
                                 context: self)
        }
        .subscribe()
        .disposed(by: disposeBag)

        // 头部状态
        loadNew
        .mapTo(false)
        .drive(refreshInput.headerRefreshState)
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
        .drive(refreshInput.footerRefreshState)
        .disposed(by: disposeBag)
    }

    private func refresh(_ refreshing: Driver<Void>) -> Driver<[UGCVideoListModel]> {

        return  refreshing
                .withLatestFrom(category.asDriverOnErrorJustComplete()) { $1 }
                .flatMapLatest { [unowned self] in
                    self.request(category: $0)
                }
    }

    private func getUrls(_ items: Driver<[UGCVideoListModel]>) -> Driver<[URL]> {
        return  items
                .map {
                    $0.map {
                        URL(string: $0.content.raw_data.video.play_addr.url_list.first ?? "")
                    }
                    .compactMap { $0 }
                }
    }
}

extension UGCVideoListViewModel {

    /// 加载小视频
    func request(category: String) -> Driver<[UGCVideoListModel]> {

        return  VideoApi
                .ugcList(category)
                .request()
                .mapObject([UGCVideoListModel].self)
                .trackActivity(loading)
                .trackError(refreshError)
                .asDriverOnErrorJustComplete()
    }
}
