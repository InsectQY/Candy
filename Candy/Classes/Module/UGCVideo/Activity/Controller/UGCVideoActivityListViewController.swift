//
//  UGCVideoActivityListViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UGCVideoActivityListViewController: TableViewController {

    // MARK: - Lazyload
    private let viewModel = UGCVideoActivityViewModel()

    // MARK: - Init
    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func makeUI() {

        super.makeUI()

        tableView.register(cellType: UGCVideoActivityCell.self)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoActivityViewModel.Input(headerRefresh: tableView.refreshHeader.rx.refreshing.asDriver(),
                                                    footerRefresh: tableView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: UGCVideoActivityCell.ID, cellType: UGCVideoActivityCell.self)) { collectionView, item, cell in
            cell.item = item
        }.disposed(by: rx.disposeBag)

        // 刷新状态
        output.endHeaderRefresh
        .drive(tableView.refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)

        output.endFooterRefresh
        .drive(tableView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}
