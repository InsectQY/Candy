//
//  BaseTableViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

/// 继承时需指定 RefreshViewModel 或其子类作为泛型。
/// 该类实现 UITableView 的 header / footer 刷新逻辑。
class TableViewController<RVM: RefreshViewModel>: ViewController<RVM> {

    private var style: UITableView.Style = .plain

    // MARK: - Lazyload
    lazy var tableView: TableView = {

        let tableView = TableView(frame: view.bounds,
                                  style: style)
        return tableView
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - init
    init(style: UITableView.Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - override
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        view.addSubview(tableView)
    }

    /// 子类调用 super.bindViewModel 会自动创建 viewModel 对象。
    /// 如果不需要自动创建 viewModel，不调用 super 即可。
    override func bindViewModel() {
        super.bindViewModel()

        bindReloadEmpty()
        bindHeader()
        bindFooter()

        viewModel.bindState()
    }

    // MARK: - 开始头部刷新
    func beginHeaderRefresh() {
        tableView.refreshHeader?.beginRefreshing { [weak self] in
            self?.setUpEmptyDataSet()
        }
    }

    // MARK: - 设置 DZNEmptyDataSet
    func setUpEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
        .map { _ in false }
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

    // MARK: - 绑定数据源 nil 的占位图
    func bindReloadEmpty() {

        viewModel.loading
        .distinctUntilChanged()
        .mapToVoid()
        .drive(tableView.rx.reloadEmptyDataSet)
        .disposed(by: rx.disposeBag)
    }
}
