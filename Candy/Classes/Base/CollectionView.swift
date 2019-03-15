//
//  CollectionView.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {

    init() {
        super.init(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        makeUI()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {

        layer.masksToBounds = true
        backgroundColor = .clear
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func itemWidth(forItemsPerRow itemsPerRow: Int, withInset inset: CGFloat = 0) -> CGFloat {

        let collectionWidth = Int(frame.size.width)
        if collectionWidth == 0 {
            return 0
        }
        return CGFloat(Int((collectionWidth - (itemsPerRow + 1) * Int(inset)) / itemsPerRow))
    }
}
