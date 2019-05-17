//
//  UGCVideoActivityListViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UGCVideoActivityListViewController: TableViewController<UGCVideoActivityViewModel> {

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

        guard let viewModel = viewModel else { return }

        let output = viewModel.transform(input: UGCVideoActivityViewModel.Input())

        output.items.drive(tableView.rx.items(cellIdentifier: UGCVideoActivityCell.ID, cellType: UGCVideoActivityCell.self)) { collectionView, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)
    }
}
