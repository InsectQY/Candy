//
//  BaseViewController.swift
//  GamerSky
//
//  Created by QY on 2018/4/2.
//  Copyright © 2018年 QY. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import RxReachability
import Reachability

/// 该类实现了 UITableView / UICollectionView 数据源 nil 时的占位视图逻辑。
class ViewController: UIViewController {

    // MARK: - Lazyload

    /// 监听网络状态改变
    lazy var reachability: Reachability? = Reachability()
    /// 是否正在加载
    let isLoading = BehaviorRelay(value: false)
    /// 当前连接的网络类型
    let reachabilityConnection = BehaviorRelay(value: Reachability.Connection.none)
    /// 数据源 nil 时点击了 view
    let emptyDataSetViewTap = PublishSubject<Void>()
    /// 数据源 nil 时显示的标题，默认 " "
    var emptyDataSetTitle: String = ""
    /// 数据源 nil 时显示的描述，默认 " "
    var emptyDataSetDescription: String = ""
    /// 数据源 nil 时显示的图片
    var emptyDataSetImage = R.image.hg_defaultError()
    /// 没有网络时显示的图片
    var noConnectionImage = R.image.hg_defaultNo_connection()
    /// 没有网络时显示的标题
    var noConnectionTitle: String = R.string.localizable.appNetNoConnectionTitle()
    /// 没有网络时显示的描述
    var noConnectionDescription: String = R.string.localizable.appNetNoConnectionDesc()
    /// 数据源 nil 时是否可以滚动，默认 true
    var emptyDataSetShouldAllowScroll: Bool = true
    /// 没有网络时是否可以滚动， 默认 false
    var noConnectionShouldAllowScroll: Bool = false
    /// 垂直方向偏移量
    var verticalOffset: CGFloat = Configs.Dimensions.topH

    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        trackReachabilityState()
        makeUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        reachability?.stopNotifier()
    }

    // MARK: - override
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - deinit
    deinit {
        print("\(type(of: self)): Deinited")
    }

    // MARK: - didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(type(of: self)): Received Memory Warning")
    }

    // MARK: - init
    func makeUI() {
        // iOS 13
        modalPresentationStyle = .fullScreen
        view.backgroundColor = .white
    }

    private func trackReachabilityState() {

        reachability?.rx.reachabilityChanged
        .mapAt(\.connection)
        .bind(to: reachabilityConnection)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - EmptyDataSetSource
extension ViewController: EmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        var title = ""
        switch reachabilityConnection.value {
        case .none:
            title = noConnectionTitle
        case .cellular:
            title = emptyDataSetTitle
        case .wifi:
            title = emptyDataSetTitle
        }
        return NSAttributedString(string: title)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        var description = ""
        switch reachabilityConnection.value {
        case .none:
            description = noConnectionDescription
        case .cellular:
            description = emptyDataSetDescription
        case .wifi:
            description = emptyDataSetDescription
        }
        return NSAttributedString(string: description)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {

        switch reachabilityConnection.value {
        case .none:
            return noConnectionImage
        case .cellular:
            return emptyDataSetImage
        case .wifi:
            return emptyDataSetImage
        }
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        -verticalOffset
    }
}

// MARK: - EmptyDataSetDelegate
extension ViewController: EmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        !isLoading.value
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        emptyDataSetViewTap.onNext(())
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {

        switch reachabilityConnection.value {
        case .none:
            return noConnectionShouldAllowScroll
        case .cellular:
            return emptyDataSetShouldAllowScroll
        case .wifi:
            return emptyDataSetShouldAllowScroll
        }
    }
}
