//
//  ViewController+EmptyDataSetable.swift
//  Candy
//
//  Created by Insect on 2020/6/24.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

extension ViewController: EmptyDataSetable {

    @objc public var emptyDataSetTitle: String {
        ""
    }

    @objc public var emptyDataSetDescription: String {
        ""
    }

    @objc public var emptyDataSetImage: UIImage? {
        R.image.hg_defaultError()
    }

    @objc public var noConnectionImage: UIImage? {
        R.image.hg_defaultNo_connection()
    }

    @objc public var noConnectionTitle: String {
        R.string.localizable.appNetNoConnectionTitle()
    }

    @objc public var noConnectionDescription: String {
        R.string.localizable.appNetNoConnectionDesc()
    }

    @objc public var isNoConnectionShouldAllowScroll: Bool {
        false
    }

    @objc public var isEmptyDataSetShouldAllowScroll: Bool {
        true
    }

    @objc public var verticalOffset: CGFloat {
        .navgationBarBottomY
    }
}
