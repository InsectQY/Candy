//
//  VideoHallRoleCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/21.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallRoleCell: TableViewCell {

    public var items: [Role] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: CollectionView! {
        didSet {

            collectionView.contentInset = UIEdgeInsets(top: 0,
                                                       left: VideoHallRoleCell.KInset,
                                                       bottom: 0,
                                                       right: VideoHallRoleCell.KInset)
            collectionView.register(R.nib.roleCell)
        }
    }
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout! {
        didSet {
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: VideoHallRoleCell.kItemW,
                                         height: VideoHallRoleCell.kItemW * 2)
            flowLayout.minimumLineSpacing = VideoHallRoleCell.kMargin
            flowLayout.minimumInteritemSpacing = VideoHallRoleCell.kMargin
        }
    }
}

// MARK: - UICollectionViewDataSource
extension VideoHallRoleCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.roleCell.identifier,
                                                      for: indexPath,
                                                      cellType: RoleCell.self)

        cell.item = items[indexPath.item]
        return cell
    }
}

// MARK: - 常量
extension VideoHallRoleCell {

    /// collectionView 左右间距
    private static let KInset: CGFloat = 10
    /// cell 之间间距
    private static let kMargin: CGFloat = 20
    /// cell 宽度
    private static var kItemW: CGFloat = 60
}
