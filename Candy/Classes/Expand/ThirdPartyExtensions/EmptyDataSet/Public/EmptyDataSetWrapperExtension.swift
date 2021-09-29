//
//  EmptyDataSetWrapperExtension.swift
//  EmptyDataSetConfig
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import EmptyDataSet_Swift
import UIKit

private var context: UInt8 = 0

public extension EmptyDataSetWrapper where Base: UIScrollView {

    var config: EmptyDataSetConfig? {
        base.emptyDataSetConfig
    }

    func setConfig(_ config: EmptyDataSetConfig = EmptyDataSetConfig()) {
        base.emptyDataSetConfig = config
    }

    func reload() {
        base.reloadEmptyDataSet()
    }

    func initialize() {
        base.emptyDataSetSource = config
        base.emptyDataSetDelegate = config
    }
}

fileprivate extension UIScrollView {

    var emptyDataSetConfig: EmptyDataSetConfig? {
        get {
            objc_getAssociatedObject(self, &context) as? EmptyDataSetConfig
        }

        set {
            objc_setAssociatedObject(self,
                                     &context,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            observeEmptyDataSetConfig()
        }
    }

    private func observeEmptyDataSetConfig() {

        emptyDataSetConfig?.valueChanged = { [weak self] in
            self?.reloadEmptyDataSet()
        }
    }
}
