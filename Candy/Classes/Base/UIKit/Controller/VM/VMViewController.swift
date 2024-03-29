//
//  VMViewController.swift
//  NewRetailPlatform
//
//  Created by QY on 2020/4/26.
//  Copyright © 2020 RocketsChen. All rights reserved.
//

import UIKit

/// 继承时需指定 ViewModel 或其子类作为泛型。该类会自动懒加载指定类型的 VM 对象。
class VMViewController<VM: ViewModel>: ViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {
        bindLoading()
        bindError()
    }

    // MARK: - 绑定加载状态
    func bindLoading() {
        viewModel
        .loading
        .drive(view.rx.isLoading)
        .disposed(by: rx.disposeBag)
    }

    func bindError() {
        viewModel
        .error
        .drive(view.rx.showError)
        .disposed(by: rx.disposeBag)
    }
}

extension VMViewController: ViewModelObject {
    typealias VMType = VM
}
