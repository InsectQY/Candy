//
//  UIScrollView+EmptyDataSet.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import EmptyDataSet_Swift
import UIKit

private var context: UInt8 = 0

public extension UIScrollView {
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
        if let title = emptyDataSet?.title {
            return NSAttributedString(string: title)
        } else {
            return nil
        }
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if let description = emptyDataSet?.description {
            return NSAttributedString(string: description)
        } else {
            return nil
        }
    }

    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        emptyDataSet?.image
    }

    public func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        emptyDataSet?.imageTintColor
    }

    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        emptyDataSet?.imageAnimation
    }

    public func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        emptyDataSet?.customView
    }

    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        emptyDataSet?.backgroundColor
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

    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        emptyDataSet?.isShouldAllowTouch ?? true
    }

    public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        emptyDataSet?.didTapButton?()
    }

    public func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        emptyDataSet?.willAppear?()
    }

    public func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        emptyDataSet?.didAppear?()
    }

    public func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        emptyDataSet?.willDisappear?()
    }

    public func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        emptyDataSet?.didDisappear?()
    }
}

// MARK: - LoadingStateable

extension UIScrollView: LoadingStateable {
    func loadingStateChanged() {
        reloadEmptyDataSet()
    }
}
