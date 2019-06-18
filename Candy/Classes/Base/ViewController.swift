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

/// 继承时需指定 ViewModel 或其子类作为泛型。该类会自动懒加载指定类型的 VM 对象。
/// 该类实现了 UITableView / UICollectionView 数据源 nil 时的占位视图逻辑。
class ViewController<VM: ViewModel>: UIViewController {

    // MARK: - Lazyload

    /// 不使用该对象时，不会被初始化
    lazy var viewModel: VM = {

        guard
            let classType = "\(VM.self)".classType(VM.self)
        else {
            return VM()
        }
        let viewModel = classType.init()
        viewModel
        .loading
        .drive(isLoading)
        .disposed(by: rx.disposeBag)

        viewModel
        .error
        .drive(rx.showError)
        .disposed(by: rx.disposeBag)
        return viewModel
    }()

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
        makeUI()
        bindViewModel()
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
        view.backgroundColor = .white
    }

    func bindViewModel() {

        reachability?.rx.reachabilityChanged
        .mapAt(\.connection)
        .bind(to: reachabilityConnection)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定是否正在加载
    func bindLoadingToIndicator() {

        viewModel
        .loading
        .drive(rx.isAnimating)
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
        return .clear
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return -verticalOffset
    }
}

// MARK: - EmptyDataSetDelegate
extension ViewController: EmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return !isLoading.value
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
