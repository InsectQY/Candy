//
//  BaseTableViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import RxReachability
import Reachability

class TableViewController: ViewController {

    private var style: UITableView.Style = .plain

    // MARK: - Lazyload
    lazy var tableView: TableView = {

        let tableView = TableView(frame: view.bounds, style: style)
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

    override func bindViewModel() {
        super.bindViewModel()

        isLoading.asDriver()
        .distinctUntilChanged()
        .mapToVoid()
        .drive(rx.reloadEmptyDataSet)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 设置 DZNEmptyDataSet
    func setUpEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
}

// MARK: - Refreshable
extension TableViewController: Refreshable {

    var header: ControlEvent<Void> {
        return tableView.refreshHeader.rx.refreshing
    }

    var footer: ControlEvent<Void> {
        return tableView.refreshFooter.rx.refreshing
    }
}

// MARK: - Refresh
extension TableViewController {

    // MARK: - 开始刷新
    func beginHeaderRefresh() {
        tableView.refreshHeader.beginRefreshing { [weak self] in
            self?.setUpEmptyDataSet()
        }
    }

    func bindHeaderRefresh(with state: PublishSubject<Bool>) {
        state
        .asObservable()
        .bind(to: tableView.refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)
    }

    func bindFooterRefresh(with state: PublishSubject<RxMJRefreshFooterState>) {
        state
        .asObservable()
        .bind(to: tableView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - Reactive-extension
extension Reactive where Base: TableViewController {

    var reloadEmptyDataSet: Binder<Void> {

        return Binder(base) { vc, _ in
            vc.tableView.reloadEmptyDataSet()
        }
    }

    var beginHeaderRefresh: Binder<Void> {

        return Binder(base) { vc, _ in
            vc.beginHeaderRefresh()
        }
    }
}
