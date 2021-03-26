//
//  ScrollView.swift
//  Candy
//
//  Created by Insect on 2019/3/1.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {}

    func updateUI() {
        setNeedsDisplay()
    }
}
