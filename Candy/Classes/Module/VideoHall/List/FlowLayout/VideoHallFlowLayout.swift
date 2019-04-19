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
        return (ScreenWidth - (kMaxCol - 1) * kMargin) / kMaxCol
    }
    private var kItemH: CGFloat {
        return kItemW * 1.7
    }

    override init() {
        super.init()
        
        scrollDirection = .vertical
        itemSize = CGSize(width: kItemW, height: kItemH)
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
