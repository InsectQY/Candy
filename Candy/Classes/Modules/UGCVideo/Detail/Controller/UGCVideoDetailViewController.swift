//
//  UGCVideoDetailViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/12.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import ZFPlayer
import Hero

class UGCVideoDetailViewController: VMCollectionViewController<UGCVideoListViewModel> {

    // MARK: - LazyLoad
    private lazy var controlView = UGCVideoControlView(frame: UIScreen.main.bounds)
    private lazy var player: ZFPlayerController = {

        let playerManager = ZFIJKPlayerManager()
        playerManager.scalingMode = .aspectFill
        let player = ZFPlayerController(scrollView: collectionView,
                                        playerManager: playerManager,
                                        containerViewTag: 100)
        player.controlView = controlView
        player.shouldAutoPlay = true
        player.isWWANAutoPlay = true
        player.playerDisapperaPercent = 1.0
        player.allowOrentitaionRotation = false
        player.disableGestureTypes = .pan
        return player
    }()

    private var myViewModel: UGCVideoListViewModel?

    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.qy.setIsTransparent(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        disablesAdjustScrollViewInsets(collectionView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.qy.setIsTransparent(false)
        navigationController?.navigationBar.qy.backgroundColor = .main
    }

    // MARK: - convenience
    init(viewModel: UGCVideoListViewModel) {
        super.init(collectionViewLayout: UGCVideoDetailFlowLayout())
        self.viewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        setUpBarItem()
        collectionView.delegate = self
        collectionView.register(R.nib.ugcVideoDetailCell)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.zf_scrollViewDirection = .horizontal
        addPanGesture()
    }

    private func addPanGesture() {

        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(panned(_:)))
        panGestureRecognizer.delegate = self
        collectionView.addGestureRecognizer(panGestureRecognizer)
    }

    private func setUpBarItem() {
        let backItem = BarButtonItem(image: R.image.imgPic_close_24x24_(),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backBtnDidClick))
        navigationItem.leftBarButtonItem = backItem
    }

    @objc private func backBtnDidClick() {
        dismiss(animated: true, completion: nil)
    }

    override func bindViewModel() {

        // 数据源
        viewModel.output
        .items
        .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.ugcVideoDetailCell.identifier,
                                       cellType: UGCVideoDetailCell.self)) { _, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        // 视频 URL
        viewModel.output
        .videoURLs
        .drive(player.rx.assetURLs)
        .disposed(by: rx.disposeBag)

        // 滚动到指定位置
        viewModel.output
        .indexPath
        .drive(collectionView.rx.scrollToItem(at: .centeredHorizontally,
                                              animated: false))
        .disposed(by: rx.disposeBag)

        // 播放视频
        viewModel.output
        .indexPath
        .drive(onNext: { [weak self] in

            self?.collectionView.layoutIfNeeded()
            self?.playAtTheIndexPath($0)
        })
        .disposed(by: rx.disposeBag)

        // 滑动结束时加载更多视频
        collectionView.rx.willDisplayCell
        .withLatestFrom(viewModel.output.items) {
            (willDisplay: $0, video: $1)
        }
        .filter {
            $0.willDisplay.at.item == $0.video.count - 2
        }
        .mapToVoid()
        .bind(to: viewModel.refreshInput.footerRefreshOb)
        .disposed(by: rx.disposeBag)

        // 滑动时自动播放视频
        collectionView.zf_scrollViewDidEndScrollingCallback = { [weak self] in
            self?.playAtTheIndexPath($0)
        }

        // 播放结束时重新播放
        player.playerDidToEnd = { [weak self] _ in
            self?.player.currentPlayerManager.replay()
        }
    }

    // 播放视频
    private func playAtTheIndexPath(_ indexPath: IndexPath) {

        guard
            let cell = collectionView.cellForItem(at: indexPath) as? UGCVideoDetailCell
        else {
            return
        }
        player.playTheIndexPath(indexPath)
        controlView.coverImageURL = cell.item?.videoInfo.coverImg.urls.first?.url
        controlView.resetControlView()
    }
}

extension UGCVideoDetailViewController {

    @objc private func panned(_ recognizer: UIPanGestureRecognizer) {

        guard
            let cell = collectionView.visibleCells.first as? UGCVideoDetailCell
        else {
            return
        }
        let translation = recognizer.translation(in: nil)
        let progress = translation.y / 2 / collectionView.bounds.height
        switch recognizer.state {
        case .began:
            hero.dismissViewController()
        case .changed:
            navigationItem.leftBarButtonItem = nil
            cell.isPanned = true
            Hero.shared.update(progress)
            let currentPos = CGPoint(x: translation.x + view.center.x,
                                     y: translation.y + view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPos)],
                              to: cell)
        default:

            if progress + recognizer.velocity(in: nil).y / collectionView.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
                cell.isPanned = false
                setUpBarItem()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension UGCVideoDetailViewController: UICollectionViewDelegate {

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

// MARK: - UIGestureRecognizerDelegate
extension UGCVideoDetailViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

         // 只响应下滑手势
        guard
            let pan = gestureRecognizer as? UIPanGestureRecognizer
        else {
            return true
        }
        let v = pan.velocity(in: nil)
        return v.y > abs(v.x)
    }
}
