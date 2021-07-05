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

class VideoDetailViewController: VMTableViewController<VideoDetailViewModel> {

    private var video: NewsModel?
    private var seekTime: TimeInterval = 0

    // MARK: - Lazyload
    private lazy var videoView: VideoDetailHeader = {

        let videoView = R.nib.videoDetailHeader.firstView(owner: nil)!
        videoView.video = video
        return videoView
    }()

     private lazy var controlView: ZFPlayerControlView = {
       let controlView = ZFPlayerControlView()
       controlView.prepareShowLoading = true
       return controlView
    }()

    private lazy var player: ZFPlayerController = {

        let player = ZFPlayerController(playerManager: ZFIJKPlayerManager(),
                                        containerView: videoView.videoContainerView)
        player.controlView = controlView
        player.orientationWillChange = { _, isFullScreen in
            AppDelegate.shared.isAllowOrientationRotation = isFullScreen
        }
        return player
    }()

    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.isViewControllerDisappear = false
        setNavBarTransparent(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.isViewControllerDisappear = true
        setNavBarTransparent(false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: .screenWidth,
                                 height: VideoDetailHeader.height)
        tableView.frame = CGRect(x: 0,
                                 y: videoView.bottom,
                                 width: .screenWidth,
                                 height: .screenHeight - VideoDetailHeader.height)
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

    override var shouldAutorotate: Bool {
        false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override func makeUI() {
        super.makeUI()

        view.addSubview(videoView)
        tableView.estimatedRowHeight = 100
        tableView.register(R.nib.videoDetailInfoCell)
        tableView.register(R.nib.videoRelatedCell)
        tableView.register(R.nib.commentCell)
        tableView.refreshFooter = RefreshFooter()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = VideoDetailViewModel.Input(video: video,
                                               selection: tableView.rx.modelSelected(VideoDetailItem.self).asDriver())
        let output = viewModel.transform(input: input)

        // 数据源
        let dataSource = RxTableViewSectionedReloadDataSource<VideoDetailSection>(configureCell: { dataSource, tableView, indexPath, section in

            switch section {
            case let .info(item):

                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.videoDetailInfoCell.identifier,
                                                         for: indexPath,
                                                         cellType: VideoDetailInfoCell.self)
                cell.item = item
                return cell
            case let .related(item):
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.videoRelatedCell.identifier,
                                                         for: indexPath,
                                                         cellType: VideoRelatedCell.self)
                cell.item = item
                return cell
            case let .comment(item):

                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.commentCell.identifier,
                                                         for: indexPath,
                                                         cellType: CommentCell.self)
                cell.item = item
                return cell
            }
        })

        // 绑定数据源
        output.sections
        .drive(tableView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)

        // 视频真实播放地址
        output.videoPlayInfo
        .map(\.video_list.video_1.playURL)
        .filterNil()
        .drive(player.rx.assetURL)
        .disposed(by: rx.disposeBag)

        output.videoPlayInfo
        .mapToVoid()
        .drive(player.rx.seek(toTime: seekTime))
        .disposed(by: rx.disposeBag)
    }
}
