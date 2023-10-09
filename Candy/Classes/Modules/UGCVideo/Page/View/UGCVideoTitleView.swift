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

        titleColor = UIColor(red: 0.91, green: 0.92, blue: 0.98, alpha: 1.00)
        isTitleColorGradientEnabled = true
        isTitleLabelZoomEnabled = true
        titleLabelZoomScale = 1.4
        isAverageCellSpacingEnabled = false
        titleSelectedColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
