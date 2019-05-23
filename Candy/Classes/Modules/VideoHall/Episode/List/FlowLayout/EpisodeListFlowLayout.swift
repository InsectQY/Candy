//
//  EpisodeListFlowLayout.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class EpisodeListFlowLayout: UICollectionViewFlowLayout {

    /// 间距
    private let kMargin: CGFloat = 8
    /// 每行最大列数
    private let kMaxCol: CGFloat = 6
    /// cell 宽度
    private var kItemW: CGFloat {

        let contentInset = (collectionView?.contentInset.left ?? 0) + (collectionView?.contentInset.right ?? 0)
        return ((collectionView?.width ?? 0) - contentInset - (kMaxCol - 1) * kMargin) / kMaxCol
    }

    override func prepare() {
        super.prepare()

        scrollDirection = .vertical
        itemSize = CGSize(width: kItemW, height: kItemW)
        minimumLineSpacing = kMargin
        minimumInteritemSpacing = kMargin
    }
}
