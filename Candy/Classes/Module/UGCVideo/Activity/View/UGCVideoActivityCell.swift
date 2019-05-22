//
//  UGCVideoActivityCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UGCVideoActivityCell: TableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            collectionViewHeightConstraint.constant = UGCVideoActivityCell.kItemH
        }
    }
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.itemSize = CGSize(width: UGCVideoActivityCell.kItemW, height: UGCVideoActivityCell.kItemH)
            flowLayout.minimumLineSpacing = UGCVideoActivityCell.kMargin
            flowLayout.minimumInteritemSpacing = UGCVideoActivityCell.kMargin
        }
    }
    @IBOutlet private weak var collectionView: CollectionView! {
        didSet {
            collectionView.register(R.nib.imageCell)
        }
    }
    @IBOutlet private weak var participateBtn: Button!
    @IBOutlet private weak var categoryLabel: Label!
    @IBOutlet private weak var nameLabel: Label!

    public var item: UGCVideoActivityAlbumList? {
        didSet {

            guard let item = item else { return }

            nameLabel.text = item.album_info.album_name
            categoryLabel.text = item.album_info.album_label
            participateBtn
            .setTitle(item.album_info.album_participate_info, for: .normal)
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension UGCVideoActivityCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let item = item else { return 0 }
        return item.video_list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.imageCell.identifier,
                                                      for: indexPath,
                                                      cellType: ImageCell.self)
        cell.item = item?.video_list[indexPath.row].raw_data.video.origin_cover.url_list.first
        return cell
    }
}

// MARK: - 常量
extension UGCVideoActivityCell {

    /// cell 之间间距
    private static let kMargin: CGFloat = 2
    /// 每行最大列数
    private static let kMaxCol: CGFloat = 3
    /// cell 宽度
    private static var kItemW: CGFloat {
        return (ScreenWidth - (UGCVideoActivityCell.kMaxCol - 1) * UGCVideoActivityCell.kMargin) / UGCVideoActivityCell.kMaxCol
    }

    private static var kItemH: CGFloat {
        return UGCVideoActivityCell.kItemW * 1.5
    }
}
