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
        var codeOb: AnyObserver<String>
        /// 点击
        let selectionOb: AnyObserver<IndexPath>
    }

    struct Output {

        /// 所有视频
        let items: Driver<[UGCListModel]>
        /// 所有需要播放视频的 URL
        let videoURLs: Driver<[URL]>
        /// 已经选中的视频
        let indexPath: Driver<IndexPath>
    }

    /// 点击
    private let selection = PublishSubject<IndexPath>()
    /// code
    private let code = PublishSubject<String>()

    // 所有视频
    private let elements = BehaviorRelay<[UGCListModel]>(value: [])
    // 所有需要播放的视频 URL
    private let videoURLs = BehaviorRelay<[URL]>(value: [])
    // 当前选中的
    private let indexPath = BehaviorRelay<IndexPath>(value: IndexPath(item: 0,
                                                                      section: 0))
    // 分页
    private var page = 1

    required init() {

        input = Input(codeOb: code.asObserver(), selectionOb: selection.asObserver())
        output = Output(items: elements.asDriver(),
                        videoURLs: videoURLs.asDriver(),
                        indexPath: indexPath.asDriver())
        super.init()
    }

    override func transform() {
        super.transform()

        // 下拉刷新
        let loadNew = refresh(refreshOutput.headerRefreshing, page: 1)

        // 上拉加载
        let loadMore = refresh(refreshOutput.footerRefreshing, page: page + 1)

        loadNew.drive { [weak self] _ in
            self?.page = 1
        }

        loadMore.drive { [weak self] _ in
            self?.page += 1
        }

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
            loadNew.mapToFooterStateDefault(),
            loadMore.mapToFooterStateDefault()
        )
        .startWith(.hidden)
        .drive(refreshInput.footerRefreshStateOb)
        .disposed(by: disposeBag)
    }

    private func refresh(_ refreshing: Driver<Void>, page: Int) -> Driver<[UGCListModel]> {

        refreshing
        .withLatestFrom(code.asDriverOnErrorJustComplete())
        .flatMapLatest { [unowned self] in
            self.request(code: $0, page: page)
        }
    }

    private func getUrls(_ items: Driver<[UGCListModel]>) -> Driver<[URL]> {
        items
        .map {
            $0.compactMap { URL(string: $0.videoUrl) }
        }
    }
}

extension UGCVideoListViewModel {

    /// 加载小视频
    func request(code: String, page: Int) -> Driver<[UGCListModel]> {

        MacoooApi
        .list(code: code, page: page)
        .request()
        .mapObject([UGCListModel].self)
        .trackError(refreshError)
        .trackActivity(loading)
        .asDriverOnErrorJustComplete()
    }
}
