//
//  CollectionViewCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    public var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
