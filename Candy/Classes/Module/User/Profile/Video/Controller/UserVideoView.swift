//
//  UserVideoViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/2.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserVideoView: UIView {

    public var scrollCallback: ((UIScrollView?) -> Void)?
    /// 分类
    private var category: String = ""
    /// 访问用户的 ID
    private var visitedID: String = ""

    // MARK: - Lazyload
    private lazy var tableView: TableView = {

        let tableView = TableView(frame: bounds)
        tableView.delegate = self
        tableView.register(cellType: UserVideoCell.self)
        tableView.refreshFooter = RefreshFooter()
        return tableView
    }()

    private lazy var viewModel = UserVideoViewModel()

    // MARK: - LifeCylce
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(category: String, visitedID: String) {
        self.init()
        self.category = category
        self.visitedID = visitedID
        makeUI()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
}

extension UserVideoView {

    private func makeUI() {
        addSubview(tableView)
    }

    private func bindViewModel() {

        let input = UserVideoViewModel.Input(category: category,
                                             visitedID: visitedID,
                                             footerRefresh: tableView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: UserVideoCell.ID, cellType: UserVideoCell.self)) { tableView, item, cell in
            cell.item = item
        }.disposed(by: rx.disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension UserVideoView: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

// MARK: - JXPagerViewListViewDelegate
extension UserVideoView: JXPagerViewListViewDelegate {

    func listView() -> UIView! {
        return self
    }

    func listScrollView() -> UIScrollView! {
        return tableView
    }

    func listViewDidScrollCallback(_ callback: ((UIScrollView?) -> Void)!) {
        scrollCallback = callback
    }
}
