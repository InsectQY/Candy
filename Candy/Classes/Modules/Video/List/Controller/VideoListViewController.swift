//
//  VideoViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/4.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import ZFPlayer

class VideoListViewController: VMTableViewController<VideoListViewModel> {

    /// 视频类型
    private var category: String = ""
    /// 视频已经播放的时间
    private var currentTime: TimeInterval = 0

    // MARK: - LazyLoad
    private lazy var controlView = ZFPlayerControlView()
    private lazy var player: ZFPlayerController = {

        let player = ZFPlayerController(scrollView: tableView,
                                        playerManager: ZFIJKPlayerManager(),
                                        containerViewTag: 100)
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

        tableView.delegate = self
        tableView.rowHeight = VideoListCell.height
        tableView.register(R.nib.videoListCell)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        tableView.refreshHeader?.beginRefreshing { [weak self] in
            self?.tableView.setUpEmptyDataSet()
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = VideoListViewModel.Input(category: category)
        let output = viewModel.transform(input: input)

        // 数据源 nil 时点击
        tableView.rx.emptyDataSetDidTapView()
        .bind(to: rx.post(name: Notification.videoNoConnectClick))
        .disposed(by: rx.disposeBag)

        // 视频 URL
        output
        .videoURLs
        .drive(player.rx.assetURLs)
        .disposed(by: rx.disposeBag)

        // 界面左右滚动/下拉刷新/上拉加载都停止播放视频
        NotificationCenter.default.rx
        .notification(Notification.pageDidScroll)
        .mapToVoid()
        .bind(to: player.rx.stop)
        .disposed(by: rx.disposeBag)

        viewModel
        .refreshOutput
        .headerRefreshing
        .drive(player.rx.stop)
        .disposed(by: rx.disposeBag)

        viewModel
        .refreshOutput
        .footerRefreshing
        .drive(player.rx.stop)
        .disposed(by: rx.disposeBag)

        // TableView 数据源
        output.items.drive(tableView.rx.items) { [unowned self] tableView, row, item in

            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.videoListCell.identifier,
                                                     for: indexPath,
                                                     cellType: VideoListCell.self)
            cell.item = item.content

            // 视频播放点击
            cell.videoBtn.rx.tap
            .mapTo(indexPath)
            .bind(to: self.player.rx.playTheIndexPath())
            .disposed(by: cell.disposeBag)

            // 视频信息
            cell.videoBtn
            .rx.tap
            .bind(to: self.controlView.rx.showTitle(item.content.title,
                                                    coverURLString: item.content.video_detail_info.detail_video_large_image.url,
                                                    fullScreenMode: .landscape))
            .disposed(by: cell.disposeBag)

            return cell
        }
        .disposed(by: rx.disposeBag)

        // tableView 点击事件
        tableView.rx.modelSelected(NewsListModel.self)
        .map(\.content)
        .map { [unowned self] in
            ["news": $0,
             "seekTime": self.currentTime]
        }
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

        player.playerPlayTimeChanged = { [weak self] _, currentTime, _ in
            self?.currentTime = currentTime
        }

        player.playerDidToEnd = { [weak self] _ in
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
