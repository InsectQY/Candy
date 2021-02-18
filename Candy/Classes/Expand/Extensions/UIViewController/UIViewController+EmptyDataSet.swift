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
        case .unavailable, .none:
            title = noConnectionTitle
        case .cellular, .wifi:
            title = emptyDataSetTitle
        }
        return NSAttributedString(string: title)
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        var description = ""
        switch ReachabilityManager.shared.reachabilityConnection.value {
        case .unavailable, .none:
            description = noConnectionDescription
        case .cellular, .wifi:
            description = emptyDataSetDescription
        }
        return NSAttributedString(string: description)
    }

    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {

        switch ReachabilityManager.shared.reachabilityConnection.value {
        case .unavailable, .none:
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
        case .none, .unavailable:
            return isNoConnectionShouldAllowScroll
        case .cellular, .wifi:
            return isEmptyDataSetShouldAllowScroll
        }
    }
}
