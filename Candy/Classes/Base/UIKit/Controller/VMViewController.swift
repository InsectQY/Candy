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

    // MARK: - Lazyload

    /// 不使用该对象时，不会被初始化
    lazy var viewModel: VM = {

        guard
            let classType: VM.Type = "\(VM.self)".classType()
        else {
            return VM()
        }
        let viewModel = classType.init()
        viewModel
        .loading
        .drive(rx.isLoading)
        .disposed(by: rx.disposeBag)

        viewModel
        .error
        .drive(rx.showError)
        .disposed(by: rx.disposeBag)
        return viewModel
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {

    }
}
