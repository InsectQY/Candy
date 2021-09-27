//
//  VideoHallEpisodeCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/20.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallEpisodeCell: TableViewCell {

    @IBOutlet private weak var moreBtn: Button!

    public var items: [CellList] = []

    /// 当前选择的集数
    public var selIndex: Int = 0 {
        didSet {

            collectionView.scrollToItem(at: IndexPath(item: selIndex,
                                                      section: 0),
                                        at: .left,
                                        animated: false)
            collectionView.reloadData()
        }
    }

    @IBAction private func moreBtnDidClick(_ sender: Any) {

        let vc = EpisodeViewController(totalCount: items.count,
                                       selIndex: selIndex)
        let animator = JellyManager.episodeAnimator()
        animator.prepare(presentedViewController: vc)
        parentVC?.present(vc, animated: true, completion: nil)
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            collectionViewHeightConstraint.constant = VideoHallEpisodeCell.kItemW
        }
    }

    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.itemSize = CGSize(width: VideoHallEpisodeCell.kItemW,
                                         height: VideoHallEpisodeCell.kItemW)
            flowLayout.minimumLineSpacing = VideoHallEpisodeCell.kMargin
            flowLayout.minimumInteritemSpacing = VideoHallEpisodeCell.kMargin
        }
    }

    @IBOutlet private weak var collectionView: CollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0,
                                                       left: VideoHallEpisodeCell.KInset,
                                                       bottom: 0,
                                                       right: VideoHallEpisodeCell.KInset)
            collectionView.register(R.nib.episodeCell)
        }
    }

    override func makeUI() {

        // 刷新界面, 播放视频
        NotificationCenter.default.rx
        .notification(.clickEpisode)
        .asDriverOnErrorJustComplete()
        .map { $0.object as? Int }
        .filterNil()
        .drive(rx.selIndex)
        .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension VideoHallEpisodeCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.episodeCell.identifier,
                                                      for: indexPath,
                                                      cellType: EpisodeCell.self)
        cell.item = "\(indexPath.item + 1)"
        cell.isSel = indexPath.item == selIndex
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension VideoHallEpisodeCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default
        .post(name: .clickEpisode, object: indexPath.item)
    }
}

// MARK: - Reactive
extension Reactive where Base: VideoHallEpisodeCell {

    var selIndex: Binder<Int> {

        Binder(base) { cell, result in
            cell.selIndex = result
        }
    }
}

// MARK: - 常量
extension VideoHallEpisodeCell {

    /// collectionView 左右间距
    private static let KInset: CGFloat = 10
    /// cell 之间间距
    private static let kMargin: CGFloat = 10
    /// 每行最大列数
    private static let kMaxCol: CGFloat = 6
    /// cell 宽度
    public static var kItemW: CGFloat {
        (.screenWidth - (VideoHallEpisodeCell.kMaxCol - 1) * VideoHallEpisodeCell.kMargin - VideoHallEpisodeCell.KInset * 2) / VideoHallEpisodeCell.kMaxCol
    }
}
