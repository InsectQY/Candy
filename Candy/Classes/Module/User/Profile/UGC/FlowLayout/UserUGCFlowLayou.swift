//
//  UserUGCFlowLayou.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserUGCFlowLayout: UICollectionViewFlowLayout {

    /// 每行最大列数
    private let kMaxCol: CGFloat = 3
    /// 行间距
    private let kMargin: CGFloat = 1
    /// cell 宽度
    private var kItemW: CGFloat {
        return (ScreenWidth - (kMaxCol - 1) * kMargin) / kMaxCol
    }
    private var kItemH: CGFloat {
        return kItemW * 1.6
    }

    override init() {
        super.init()
        scrollDirection = .vertical
        itemSize = CGSize(width: kItemW, height: kItemH)
        minimumLineSpacing = kMargin
        minimumInteritemSpacing = kMargin
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
