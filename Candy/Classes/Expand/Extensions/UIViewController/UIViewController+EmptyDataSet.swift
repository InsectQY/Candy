//
//  UIViewController+EmptyDataSet.swift
//  Candy
//
//  Created by Insect on 2020/6/16.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation
import EmptyDataSet_Swift

/// 该类实现了 UITableView / UICollectionView@objc  数据源 nil 时的占位视图逻辑。

// MARK: - EmptyDataSetS@objc ource
extension ViewController: EmptyDataSetSource {

    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        var title = ""
        switch ReachabilityManager.shared.reachabilityConnection.value {
        case .none:
            title = noConnectionTitle
        case .cellular, .wifi:
            title = emptyDataSetTitle
        }
        return NSAttributedString(string: title)
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        var description = ""
        switch ReachabilityManager.shared.reachabilityConnection.value {
        case .none:
            description = noConnectionDescription
        case .cellular, .wifi:
            description = emptyDataSetDescription
        }
        return NSAttributedString(string: description)
    }

    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {

        switch ReachabilityManager.shared.reachabilityConnection.value {
        case .none:
            return noConnectionImage
        case .cellular, .wifi:
            return emptyDataSetImage
        }
    }

    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        .clear
    }

    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        -verticalOffset
    }
}

// MARK: - EmptyDataSetDelegate
extension ViewController: EmptyDataSetDelegate {

    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        !isLoading
    }

    public func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        emptyDataSetDidTapView?()
    }

    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {

        switch ReachabilityManager.shared.reachabilityConnection.value {
        case .none:
            return isNoConnectionShouldAllowScroll
        case .cellular, .wifi:
            return isEmptyDataSetShouldAllowScroll
        }
    }
}

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
        Configs.Dimensions.topH
    }
}
