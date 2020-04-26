//
//  UserCenterViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserCenterViewController: VMTableViewController<UserCenterViewModel> {

    // MARK: - Lazyload
    private lazy var headerView: UserCenterHeaderView = {

        let headerView = R.nib.userCenterHeaderView.firstView(owner: nil)!
        headerView.frame = CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: UserCenterHeaderView.height)
        return headerView
    }()

    // MARK: - init
    init() {
        super.init(style: .plain)
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

        navigationItem.title = "我的"
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UserCenterCell.height
        tableView.register(R.nib.userCenterCell)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let output = viewModel.transform(input: UserCenterViewModel.Input(loginTap: headerView.nameBtn.rx.tap))

        output.dataSource
        .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.userCenterCell.identifier,
                                  cellType: UserCenterCell.self)) { tableView, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        tableView.rx.modelSelected(UserCenterModel.self)
        .subscribe(onNext: {

            switch $0.type {
            case .collect: // 收藏
                break
            case .setting: // 设置
                break
            case .statement: // 免责声明
                navigator.push(UserURL.statement.path)
            }
        })
        .disposed(by: rx.disposeBag)

        output.loginResult
        .drive(headerView.rx.userInfo)
        .disposed(by: rx.disposeBag)

        output.loginResult
        .drive(userManager.rx.loginSuccess)
        .disposed(by: rx.disposeBag)
    }
}
