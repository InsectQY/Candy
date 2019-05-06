//
//  VideoViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/4.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import ZFPlayer
import JXCategoryView

class VideoListViewController: TableViewController {

    /// 视频类型
    private var category: String = ""
    /// 视频已经播放的时间
    private var currentTime: TimeInterval = 0

    // MARK: - Lazyload
    private lazy var viewModel = VideoListViewModel(input: self)

    fileprivate lazy var controlView = ZFPlayerControlView()
    fileprivate lazy var player: ZFPlayerController = {

        let playerManager = ZFAVPlayerManager()
        let player = ZFPlayerController(scrollView: tableView, playerManager: playerManager, containerViewTag: 100)
        player.controlView = controlView
        player.shouldAutoPlay = false
        player.playerDisapperaPercent = 1.0
        return player
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVideo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stop()
    }

    // MARK: - init
    init(category: String) {
        self.category = category
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(cellType: VideoListCell.self)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        tableView.delegate = self

        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = VideoListViewModel.Input(category: category)
        let output = viewModel.transform(input: input)

        // 没有网络时点击
        noConnectionViewTap
        .bind(to: rx.postNotification)
        .disposed(by: rx.disposeBag)

        // 视频 URL
        output.videoURLs
        .drive(rx.videoURLs)
        .disposed(by: rx.disposeBag)

        // 界面左右滚动/下拉刷新/上拉加载都停止播放视频
        NotificationCenter.default.rx
        .notification(Notification.pageDidScroll)
        .mapToVoid()
        .bind(to: rx.videoStop)
        .disposed(by: rx.disposeBag)

        viewModel.headerRefreshState
        .asObservable()
        .mapToVoid()
        .bind(to: rx.videoStop)
        .disposed(by: rx.disposeBag)

        viewModel.footerRefreshState
        .asObservable()
        .mapToVoid()
        .bind(to: rx.videoStop)
        .disposed(by: rx.disposeBag)

        // TableView 数据源
        output.items.drive(tableView.rx.items) { [unowned self] tableView, row, item in

            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: VideoListCell.self)
            cell.item = item.news

            // 视频播放点击
            cell.videoBtn.rx.tap.map { _ in indexPath }
            .bind(to: self.rx.videoTap)
            .disposed(by: cell.disposeBag)

            // 视频信息
            cell.videoBtn.rx.tap.map { _ in item.news }
            .bind(to: self.rx.videoInfo)
            .disposed(by: cell.disposeBag)

            return cell
        }
        .disposed(by: rx.disposeBag)

        // tableView 点击事件
        tableView.rx.modelSelected(NewsListModel.self)
        .map { $0.news }
        .filterNil()
        .map { [unowned self] in
            ["news": $0,
            "seekTime": self.currentTime] }
        .flatMap {
            navigator.rx.push(VideoURL.detail.path,
                              context: $0)
        }
        .subscribe { [weak self] _ in self?.currentTime = 0 }
        .disposed(by: rx.disposeBag)
    }
}

extension VideoListViewController {

    private func setUpVideo() {

        player.playerPlayTimeChanged = { [weak self] asset, currentTime, duration in
            self?.currentTime = currentTime
        }

        player.playerDidToEnd = { [weak self] asset in
            self?.currentTime = 0
        }
    }
}

// MARK: - UITableViewDelegate
extension VideoListViewController: UITableViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidEndDecelerating()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.zf_scrollViewDidEndDraggingWillDecelerate(decelerate)
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScrollToTop()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewDidScroll()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.zf_scrollViewWillBeginDragging()
    }
}

// MARK: - Reactive-Extension
extension Reactive where Base: VideoListViewController {

    var videoURLs: Binder<[URL?]> {
        return Binder(base) { vc, result in
            vc.player.assetURLs = result.compactMap { $0 }
        }
    }

    var videoTap: Binder<IndexPath> {
        return Binder(base) { vc, indexPath in
            vc.player.playTheIndexPath(indexPath, scrollToTop: false)
        }
    }

    var videoInfo: Binder<NewsModel?> {
        return Binder(base) { vc, videoModel in

            guard let videoModel = videoModel else { return }
            vc.controlView.showTitle(videoModel.title, coverURLString: videoModel.video_detail_info.detail_video_large_image.url, fullScreenMode: .landscape)
        }
    }

    var videoStop: Binder<Void> {
        return Binder(base) { vc, _ in
            vc.player.stop()
        }
    }

    var postNotification: Binder<Void> {
        return Binder(base) { _, _ in
            NotificationCenter.default
            .post(name: Notification.videoNoConnectClick, object: nil)
        }
    }
}
