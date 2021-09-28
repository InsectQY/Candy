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

public extension EmptyDataSetWrapper {

    var config: EmptyDataSetConfig? {
        base.emptyDataSetConfig
    }

    func setConfig(_ config: EmptyDataSetConfig = EmptyDataSetConfig()) {
        base.emptyDataSetConfig = config
        initEmptyDataSet()
    }

    func reload() {
        base.reloadEmptyDataSet()
    }

    private func initEmptyDataSet() {
        base.emptyDataSetSource = config
        base.emptyDataSetDelegate = config
        observeEmptyDataSetConfig()
    }

    private func observeEmptyDataSetConfig() {

        config?.valueChanged = { [weak self] in
            self?.reload()
        }
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
        }
    }
}
