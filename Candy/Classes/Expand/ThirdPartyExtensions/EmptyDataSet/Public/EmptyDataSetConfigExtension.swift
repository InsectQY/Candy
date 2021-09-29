//
//  EmptyDataSetConfigExtension.swift
//  EmptyDataSetConfig
//
//  Created by Insect on 2021/9/28.
//  Copyright © 2021 Insect. All rights reserved.
//

import EmptyDataSet_Swift

// MARK: - EmptyDataSetSource

extension EmptyDataSetConfig: EmptyDataSetSource {

    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        title
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        description
    }

    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        image
    }

    public func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        imageTintColor
    }

    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        imageAnimation
    }

    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        buttonTitle?(state)
    }

    public func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        buttonImage?(state)
    }

    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        buttonBackgroundImage?(state)
    }

    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        backgroundColor
    }

    public func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        customView
    }

    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        verticalOffset
    }

    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        spaceHeight
    }
}

// MARK: - EmptyDataSetDelegate

extension EmptyDataSetConfig: EmptyDataSetDelegate {

    public func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
        isFadeIn
    }

    public func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        isBeForcedToDisplay
    }

    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        isDisplay ? !isLoading : false
    }

    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        isAllowTouch
    }

    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        isAllowScroll
    }

    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        isAnimateImageView
    }

    public func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        didTapView?()
    }

    public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        didTapButton?()
    }

    public func emptyDataSetWillAppear(_ scrollView: UIScrollView) {
        willAppear?()
    }

    public func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        didAppear?()
    }

    public func emptyDataSetWillDisappear(_ scrollView: UIScrollView) {
        willDisappear?()
    }

    public func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        didDisappear?()
    }
}
