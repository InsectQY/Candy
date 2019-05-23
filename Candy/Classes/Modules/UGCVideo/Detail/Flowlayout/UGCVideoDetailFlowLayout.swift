//
//  UGCVideoDetailFlowLayout.swift
//  QYNews
//
//  Created by Insect on 2018/12/12.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class UGCVideoDetailFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()

        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        itemSize = UIScreen.main.bounds.size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
