//
//  UserVideoViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/2.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserVideoView: View {

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
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        addSubview(tableView)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UserVideoViewModel.Input(category: category,
                                             visitedID: visitedID)
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: UserVideoCell.ID, cellType: UserVideoCell.self)) { tableView, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
}

//  swiftlint:disable force_unwrapping
extension UserVideoView: RefreshComponentable {

    var header: ControlEvent<Void> {
        return tableView.refreshHeader!.rx.refreshing
    }

    var footer: ControlEvent<Void> {
        return tableView.refreshFooter!.rx.refreshing
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
