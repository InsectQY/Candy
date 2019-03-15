//
//  VideoHallViewModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import RxURLNavigator

final class VideoHallViewModel: ViewModel {

    struct Input {

        let searchTap: Observable<Void>
        let footerRefresh: Driver<Void>
        let selection: ControlEvent<VideoHallList>
    }

    struct Output {

        /// 尾部刷新状态
        let endFooterRefresh: Driver<RxMJRefreshFooterState>
        let items: Driver<[VideoHallList]>
    }

    let searchKey = PublishSubject<String>()
}

extension VideoHallViewModel: ViewModelable {

    func transform(input: VideoHallViewModel.Input) -> VideoHallViewModel.Output {

        let elements = BehaviorRelay<[VideoHallList]>(value: [])
        // 头部刷新状态
        let headerState = BehaviorRelay<Bool>(value: true)

        let search = searchKey.asDriverOnErrorJustComplete()
        .distinctUntilChanged()
        .flatMapLatest { [unowned self] in
            self.request(offset: 0, searchKey: $0)
        }

        let morePara = Driver.combineLatest(elements.asDriver(), searchKey.asDriverOnErrorJustComplete()) { (offset: $0.count, searchKey: $1) }

        // 加载更多视频
        let footer = input.footerRefresh.withLatestFrom(morePara)
        .flatMapLatest { [unowned self] in
            self.request(offset: $0.offset, searchKey: $0.searchKey)
        }

        // 绑定数据源
        footer.map { elements.value + $0.cell_list }
        .drive(elements)
        .disposed(by: disposeBag)

        search.map { $0.cell_list }
        .drive(elements)
        .disposed(by: disposeBag)

        // collectionView 点击
        input.selection
        .flatMap { navigator.rx.push(VideoHallURL.detail.path, context: $0.album.album_id) }
        .subscribe { _ in }
        .disposed(by: disposeBag)

        // 搜索点击
        input.searchTap
        .flatMap { navigator.rx.present(VideoHallURL.search.path, context: R.string.localizable.videoHallSearchPlaceholder(), wrap: NavigationController.self) }
        .subscribe { _ in }
        .disposed(by: disposeBag)

        // 有新的筛选值时头部变成刷新状态
        search.map { _ in true }
        .drive(headerState)
        .disposed(by: disposeBag)

        // 刷新结束
        search.map { _ in false }
        .drive(headerState)
        .disposed(by: disposeBag)

        // 尾部刷新状态
        let endFooter = Driver.merge(search.map { [unowned self] in self.footerState($0.has_more, isEmpty: $0.cell_list.isEmpty) }, footer.map { [unowned self] in self.footerState($0.has_more, isEmpty: $0.cell_list.isEmpty) }).startWith(.hidden)

        let output = Output(endFooterRefresh: endFooter, items: elements.asDriver())
        return output
    }
}

extension VideoHallViewModel {

    /// 加载放映厅数据
    func request(offset: Int, searchKey: String) -> Driver<VideoHallModel> {

        return VideoHallApi.list(offset, searchKey)
        .request()
        .trackActivity(loading)
        .trackError(error)
        .mapObject(VideoHallModel.self, atKeyPath: nil)
        .asDriverOnErrorJustComplete()
    }
}
