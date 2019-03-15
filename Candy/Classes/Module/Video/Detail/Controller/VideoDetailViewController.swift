//
//  VideoDetailViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import ZFPlayer
import RxDataSources

class VideoDetailViewController: TableViewController {

    private var video: NewsModel?
    fileprivate var seekTime: TimeInterval = 0

    // MARK: - Lazyload
    private lazy var videoView: VideoDetailHeader = {

        let videoView = VideoDetailHeader.loadFromNib()
        videoView.video = video
        return videoView
    }()

    private lazy var viewModel = VideoDetailViewModel()

    fileprivate lazy var controlView = ZFPlayerControlView()
    fileprivate lazy var player: ZFPlayerController = {

        let playerManager = ZFAVPlayerManager()
        let player = ZFPlayerController(playerManager: playerManager, containerView: videoView.videoContainerView)
        player.controlView = controlView
        return player
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fd_prefersNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.isViewControllerDisappear = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.isViewControllerDisappear = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: VideoDetailHeader.height)
        tableView.frame = CGRect(x: 0, y: videoView.bottom, width: ScreenWidth, height: ScreenHeight - VideoDetailHeader.height)
    }

    // MARK: - init
    init(video: NewsModel?, seekTime: TimeInterval = 0) {
        self.video = video
        self.seekTime = seekTime
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - override
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(cellType: VideoDetailInfoCell.self)
        tableView.register(cellType: VideoRelatedCell.self)
        tableView.register(cellType: CommentCell.self)
        tableView.refreshFooter = RefreshFooter()
        view.addSubview(videoView)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = VideoDetailViewModel.Input(video: video,
                                               selection: tableView.rx.modelSelected(VideoDetailItem.self).asDriver(),
                                               footerRefresh: tableView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        // 数据源
        let dataSource = RxTableViewSectionedReloadDataSource<VideoDetailSection>(configureCell: { dataSource, tableView, indexPath, section in

            switch section {
            case let .info(item):

                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: VideoDetailInfoCell.self)
                cell.item = item
                return cell
            case let .related(item):

                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: VideoRelatedCell.self)
                cell.item = item
                return cell
            case let .comment(item):

                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentCell.self)
                cell.item = item.comment
                return cell
            }
        })

        // 绑定数据源
        output.sections
        .drive(tableView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)

        // 视频真实播放地址
        output.videoPlayInfo
        .drive(rx.videoPlayInfo)
        .disposed(by: rx.disposeBag)

        // 尾部刷新状态
        output.endFooterRefresh
        .drive(tableView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)

        // 指示器
        viewModel.loading
        .drive(rx.showIndicator)
        .disposed(by: rx.disposeBag)

        viewModel.loading
        .drive(isLoading)
        .disposed(by: rx.disposeBag)

        viewModel.error
        .drive(rx.showError)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - Reactive
extension Reactive where Base: VideoDetailViewController {

    var videoPlayInfo: Binder<VideoPlayInfo> {
        return Binder(base) { vc, result in

            guard let assetURL = URL(string: result.video_list.video_1.mainURL) else { return }
            vc.player.assetURL = assetURL
            vc.player.seek(toTime: vc.seekTime, completionHandler: nil)
        }
    }
}
