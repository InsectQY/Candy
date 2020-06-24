//
//  VMTableViewController.swift
//  NewRetailPlatform
//
//  Created by QY on 2020/4/26.
//  Copyright © 2020 RocketsChen. All rights reserved.
//

import UIKit

/// 继承时需指定 RefreshViewModel 或其子类作为泛型。
/// 该类实现 UITableView 的 header / footer 刷新逻辑。
class VMTableViewController<RVM: RefreshViewModel>: TableViewController {

    // MARK: - Lazyload

    /// 不使用该对象时，不会被初始化
    lazy var viewModel: RVM = {

        guard
            let classType: RVM.Type = "\(RVM.self)".classType()
        else {
            return RVM()
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

    /// 子类调用 super.bindViewModel 会自动创建 viewModel 对象。
    /// 如果不需要自动创建 viewModel，不调用 super 即可。
    func bindViewModel() {

        bindHeader()
        bindFooter()
        bindEmptyDataSetViewTap()
        viewModel.bindState()
    }

    // MARK: - 绑定没有网络时的点击事件
    func bindEmptyDataSetViewTap() {

        rx.emptyDataSetDidTapView()
        .subscribe(viewModel.refreshInput.emptyDataSetViewTap)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定头部刷新回调和头部刷新状态
    func bindHeader() {

        guard
            let refreshHeader = tableView.refreshHeader
        else {
            return
        }

        // 将刷新事件传递给 refreshVM
        refreshHeader.rx.refreshing
        .bind(to: viewModel.refreshInput.beginHeaderRefresh)
        .disposed(by: rx.disposeBag)

        // 成功时的头部状态
        viewModel
        .refreshOutput
        .headerRefreshState
        .drive(refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)

        // 失败时的头部状态
        viewModel
        .refreshError
        .mapTo(false)
        .drive(refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定尾部刷新回调和尾部刷新状态
    func bindFooter() {

        guard
            let refreshFooter = tableView.refreshFooter
        else {
            return
        }

        // 将刷新事件传递给 refreshVM
        refreshFooter.rx.refreshing
        .bind(to: viewModel.refreshInput.beginFooterRefresh)
        .disposed(by: rx.disposeBag)

        // 成功时的尾部状态
        viewModel
        .refreshOutput
        .footerRefreshState
        .drive(refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)

        // 失败时的尾部状态
        viewModel
        .refreshError
        .map { [weak self] _ -> RxMJRefreshFooterState in
            guard let self = self else { return .hidden }
            return self.tableView.isTotalDataEmpty ? .hidden : .default
        }
        .drive(refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}
