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

class UGCVideoDetailViewController: CollectionViewController {

    fileprivate var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var category: String = ""
    private var videoItems: [UGCVideoListModel] = []

    // MARK: - Lazyload
    fileprivate lazy var controlView = ZFDouYinControlView()
    fileprivate lazy var player: ZFPlayerController = {

        let playerManager = ZFAVPlayerManager()
        let player = ZFPlayerController(scrollView: collectionView, playerManager: playerManager, containerViewTag: 100)
        player.controlView = controlView
        player.shouldAutoPlay = true
        player.playerDisapperaPercent = 1.0
        player.allowOrentitaionRotation = false
        player.disableGestureTypes = .pan
        return player
    }()

    private lazy var viewModel = UGCVideoDetailViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        hero.isEnabled = true
    }

    // MARK: - convenience
    init(category: String, videoItems: [UGCVideoListModel], indexPath: IndexPath) {
        self.category = category
        self.videoItems = videoItems
        self.indexPath = indexPath
        super.init(collectionViewLayout: UGCVideoDetailFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func makeUI() {
        super.makeUI()
        collectionView.delegate = self
        collectionView.register(cellType: UGCVideoDetailCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.zf_scrollViewDirection = .horizontal
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
        panGestureRecognizer.delegate = self
        collectionView.addGestureRecognizer(panGestureRecognizer)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoDetailViewModel.Input(category: category,
                                                  videoDatas: videoItems)
        let output = viewModel.transform(input: input)

        output.items.drive(collectionView.rx.items) { collectionView, row, item in

            let cell = collectionView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: UGCVideoDetailCell.self)
            cell.largeImage.hero.id = "image_\(row)"
            cell.largeImage.hero.modifiers = [.position(CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height + collectionView.bounds.width / 2)),
                                              .scale(0.6),
                                              .fade]
            cell.largeImage.isOpaque = true
            cell.item = item
            return cell
        }.disposed(by: rx.disposeBag)

        output.videoURLs
        .drive(rx.videoURLs)
        .disposed(by: rx.disposeBag)

        // 滑动结束时加载更多视频
//        collectionView.rx.didEndDisplayingCell
//        .withLatestFrom(output.items) { (willDisplay: $0, video: $1) }
//        .map { $0.willDisplay.at.item == ( $0.video.count - 1) }
//        .filter { $0 == true }
//        .mapToVoid()
//        .bind(to: input.loadMore)
//        .disposed(by: rx.disposeBag)

        // 滑动时自动播放视频
        collectionView.zf_scrollViewDidStopScrollCallback = { [unowned self] indexPath in

            guard let cell = self.collectionView.cellForItem(at: indexPath) as? UGCVideoDetailCell else { return }
            self.indexPath = indexPath
            self.player.playTheIndexPath(indexPath, scrollToTop: false)
            self.controlView.resetControlView()
//            self.controlView.showCover(with: cell.largeImage.image)
            self.controlView.showCover(withUrl: cell.item?.video?.raw_data.video.origin_cover.url_list.first)
        }

        player.playerDidToEnd = { [weak self] _ in
            self?.player.currentPlayerManager.replay?()
        }

        self.collectionView.scrollToItem(at: self.indexPath,
                                         at: .left,
                                         animated: false)
        self.collectionView.layoutIfNeeded()
        player.playTheIndexPath(indexPath, scrollToTop: false)
    }
}

extension UGCVideoDetailViewController {

    @objc private func panned(_ recognizer: UIPanGestureRecognizer) {

        guard let cell = collectionView.visibleCells.first as? UGCVideoDetailCell else { return }
        let translation = recognizer.translation(in: nil)
        let progress = translation.y / 2 / collectionView.bounds.height
        switch recognizer.state {
        case .began:
            hero.dismissViewController()
        case .changed:

            cell.isPanned = true
            Hero.shared.update(progress)
            let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
            Hero.shared.apply(modifiers: [.position(currentPos)], to: cell.largeImage)
        default:

            if progress + recognizer.velocity(in: nil).y / collectionView.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
                cell.isPanned = false
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
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
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let v = pan.velocity(in: nil)
        return v.y > abs(v.x)
    }
}

// MARK: - Reactive-Extension
extension Reactive where Base: UGCVideoDetailViewController {

    var videoURLs: Binder<[URL?]> {
        return Binder(base) { vc, result in
            vc.player.assetURLs = result.compactMap { $0 }
        }
    }
}
