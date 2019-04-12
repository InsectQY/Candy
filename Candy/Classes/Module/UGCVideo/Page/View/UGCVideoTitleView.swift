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
        isTitleColorGradientEnabled = true
        isTitleLabelZoomEnabled = true
        titleLabelZoomScale = 1.2
        isAverageCellSpacingEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
