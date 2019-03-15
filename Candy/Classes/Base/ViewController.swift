//
//  BaseViewController.swift
//  GamerSky
//
//  Created by QY on 2018/4/2.
//  Copyright © 2018年 QY. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DZNEmptyDataSet
import JXCategoryView

class ViewController: UIViewController, NVActivityIndicatorViewable {

    /// 是否正在加载
    let isLoading = BehaviorRelay(value: false)
    /// 数据源 nil 时点击了 Button
    let emptyDataSetButtonTap = PublishSubject<Void>()
    /// 数据源 nil 时显示的标题
    var emptyDataSetTitle: String = ""
    /// 数据源 nil 时显示的描述
    var emptyDataSetDescription: String = ""
    /// 数据源 nil 时显示的图片
    var emptyDataSetImage = R.image.hg_defaultError()
    /// 数据源 nil 时是否可用滚动
    var emptyDataSetShouldAllowScroll: Bool = true

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
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

    }
}

 // MARK: - DZNEmptyDataSetSource
extension ViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetTitle)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetDescription)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return emptyDataSetImage
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }
}

// MARK: - DZNEmptyDataSetDelegate
extension ViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetButtonTap.onNext(())
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return emptyDataSetShouldAllowScroll
    }
}

// MARK: - JXCategoryListContentViewDelegate
extension ViewController: JXCategoryListContentViewDelegate {

    func listView() -> UIView! {
        return view
    }
}

// MARK: - Reactive-extension
extension Reactive where Base: ViewController {

    var showIndicator: Binder<Bool> {

        return Binder(base) { vc, result in

            if result {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        }
    }

    var showError: Binder<Error> {

        return Binder(base) { vc, error in
            Toast.showError(error.errorMessage, in: vc.view)
        }
    }
}
