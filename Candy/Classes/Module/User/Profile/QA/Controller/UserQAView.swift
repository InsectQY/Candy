//
//  UserQAView.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserQAView: UIView {

    public var scrollCallback: ((UIScrollView?) -> Void)?
    /// 分类
    private var category: String = ""
    /// 访问用户的 ID
    private var visitedID: String = ""

    // MARK: - Lazyload
    private lazy var tableView: TableView = {

        let tableView = TableView(frame: bounds)
        tableView.delegate = self
        tableView.register(cellType: UserQACell.self)
        tableView.refreshFooter = RefreshFooter()
        return tableView
    }()

    private lazy var viewModel = UserQAViewModel()

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

extension UserQAView {

    private func makeUI() {
        addSubview(tableView)
    }

    private func bindViewModel() {

        let input = UserQAViewModel.Input(category: category,
                                          visitedID: visitedID,
                                          footerRefresh: tableView.refreshFooter!.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        // TableView 数据源
        output.items.drive(tableView.rx.items(cellIdentifier: UserQACell.ID, cellType: UserQACell.self)) { tableView, item, cell in
            cell.item = item
        }.disposed(by: rx.disposeBag)

        // 刷新状态
        output.endFooterRefresh
        .drive(tableView.refreshFooter!.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension UserQAView: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

// MARK: - JXPagerViewListViewDelegate
extension UserQAView: JXPagerViewListViewDelegate {

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
