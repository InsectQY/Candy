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

class VideoDetailViewController: TableViewController<VideoDetailViewModel> {

    private var video: NewsModel?
    fileprivate var seekTime: TimeInterval = 0

    // MARK: - Lazyload
    private lazy var videoView: VideoDetailHeader = {

        let videoView = R.nib.videoDetailHeader.firstView(owner: nil)!
        videoView.video = video
        return videoView
    }()

    private lazy var controlView = ZFPlayerControlView()
    private lazy var player: ZFPlayerController = {

        let playerManager = ZFAVPlayerManager()
        let player = ZFPlayerController(playerManager: playerManager,
                                        containerView: videoView.videoContainerView)
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
        videoView.frame = CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: VideoDetailHeader.height)
        tableView.frame = CGRect(x: 0, y: videoView.bottom, width: Configs.Dimensions.screenWidth, height: Configs.Dimensions.screenHeight - VideoDetailHeader.height)
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

        view.addSubview(videoView)
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
        .map { URL(string: $0.video_list.video_1.mainURL) }
        .filterNil()
        .drive(player.rx.assetURL)
        .disposed(by: rx.disposeBag)

        output.videoPlayInfo
        .mapToVoid()
        .drive(player.rx.seek(toTime: seekTime))
        .disposed(by: rx.disposeBag)

        bindLoadingToIndicator()
    }
}
