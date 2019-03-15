//
//  UGCVideoTitleView.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UGCVideoTitleView: JXCategoryTitleView {

    override init(frame: CGRect) {

        super.init(frame: frame)

        titleColor = .white
        titleColorGradientEnabled = true
        titleLabelZoomEnabled = true
        titleLabelZoomScale = 1.2
        averageCellSpacingEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
