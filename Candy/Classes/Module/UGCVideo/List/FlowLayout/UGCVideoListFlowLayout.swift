//
//  UGCVideoListFlowLayout.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class UGCVideoListFlowLayout: UICollectionViewFlowLayout {

    /// 每行最大列数
    private let kMaxCol: CGFloat = 2

    private let lineSpacing: CGFloat = 1
    private let interitemSpacing: CGFloat = 1
    /// cell 宽度
    private var kItemW: CGFloat {
        return (ScreenWidth - (kMaxCol - 1) * lineSpacing) / kMaxCol
    }
    private var kItemH: CGFloat {
        return kItemW * 1.5
    }

    override init() {
        super.init()

        scrollDirection = .vertical
        itemSize = CGSize(width: kItemW, height: kItemH)
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = interitemSpacing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
