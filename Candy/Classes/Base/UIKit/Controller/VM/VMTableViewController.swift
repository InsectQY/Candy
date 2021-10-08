//
//  VMTableViewController.swift
//  NewRetailPlatform
//
//  Created by QY on 2020/4/26.
//  Copyright © 2020 RocketsChen. All rights reserved.
//

import UIKit
import RxMJ

/// 继承时需指定 RefreshViewModel 或其子类作为泛型。
/// 该类实现 UITableView 的 header / footer 刷新逻辑。
class VMTableViewController<RVM: RefreshViewModel>: TableViewController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    func bindViewModel() {

        bindError()
        bindEmptyDataSetView()
        bindHeader()
        bindFooter()
        viewModel.transform()
    }

    // MARK: - 绑定 EmptyDataSet
    func bindEmptyDataSetView() {

        guard let config = tableView.emptyDataSet.config else { return }
        // 数据源 nil 时点击
        config.rx.didTapView
            .subscribe(viewModel.refreshInput.emptyDataSetViewTapOb)
            .disposed(by: rx.disposeBag)

        viewModel
            .loading
            .drive(config.rx.isLoading)
            .disposed(by: rx.disposeBag)
    }

    func bindError() {
        viewModel
        .error
        .drive(view.rx.showError)
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
        .bind(to: viewModel.refreshInput.headerRefreshOb)
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
        .bind(to: viewModel.refreshInput.footerRefreshOb)
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

extension VMTableViewController: ViewModelObject {
    typealias VMType = RVM
}
