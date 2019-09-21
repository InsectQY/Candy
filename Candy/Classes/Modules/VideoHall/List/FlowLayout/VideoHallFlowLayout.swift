//
//  VideoHallFlowLayout.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallFlowLayout: UICollectionViewFlowLayout {

    /// 间距
    private let kMargin: CGFloat = 2
    /// 每行最大列数
    private let kMaxCol: CGFloat = 3
    /// cell 宽度
    private var kItemW: CGFloat {
        ((collectionView?.width ?? 0) - (kMaxCol - 1) * kMargin) / kMaxCol
    }
    private var kItemH: CGFloat {
        kItemW * 1.7
    }

    override func prepare() {
        super.prepare()

        scrollDirection = .vertical
        itemSize = CGSize(width: kItemW, height: kItemH)
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }
}
