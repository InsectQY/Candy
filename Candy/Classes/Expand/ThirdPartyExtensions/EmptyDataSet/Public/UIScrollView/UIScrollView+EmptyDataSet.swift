//
//  UIScrollView+EmptyDataSet.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

private var context: UInt8 = 0

extension UIScrollView {

    var emptyDataSet: EmptyDataSet? {

        get {

            if let object = objc_getAssociatedObject(self, &context) as? EmptyDataSet {
                return object
            }

            objc_setAssociatedObject(self,
                                     &context,
                                     false,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return EmptyDataSet()
        }

        set {
            objc_setAssociatedObject(self,
                                     &context,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - 设置 EmptyDataSet
    func setUpEmptyDataSet() {
        emptyDataSetSource = self
        emptyDataSetDelegate = self
    }
}

// MARK: - EmptyDataSetSource
extension UIScrollView: EmptyDataSetSource {

    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString(string: emptyDataSet?.title ?? "")
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        NSAttributedString(string: emptyDataSet?.description ?? "")
    }

    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        emptyDataSet?.image
    }

    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        .clear
    }

    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        emptyDataSet?.verticalOffset ?? 0
    }
}

// MARK: - EmptyDataSetDelegate
extension UIScrollView: EmptyDataSetDelegate {

    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        !isLoading
    }

    public func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        emptyDataSet?.didTapView?()
    }

    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        emptyDataSet?.isShouldAllowScroll ?? false
    }
}

// MARK: - LoadingStateable
extension UIScrollView: LoadingStateable {
    func loadingStateChanged() {
        reloadEmptyDataSet()
    }
}
