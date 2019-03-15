//
//  CollectionReusableView.swift
//  Candy
//
//  Created by apple on 2019/3/1.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {

    public var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
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
