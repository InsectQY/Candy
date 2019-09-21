//
//  View.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        bindViewModel()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func bindViewModel() {

    }
}
