//
//  UserArticleView.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserArticleView: View {

    public var scrollCallback: ((UIScrollView?) -> Void)?
    /// 分类
    private var category: String = ""
    /// 访问用户的 ID
    private var visitedID: String = ""

    // MARK: - Lazyload
    private lazy var tableView: TableView = {

        let tableView = TableView(frame: bounds)
        tableView.delegate = self
        tableView.register(cellType: UserArticleCell.self)
        tableView.register(cellType: UserArticleMultiImageCell.self)
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

    //  swiftlint:disable force_unwrapping
    override func bindViewModel() {
        super.bindViewModel()

        let input = UserVideoViewModel.Input(category: category,
                                             visitedID: visitedID)
        let output = viewModel.transform(input: input)

        // TableView 数据源
        output.items.drive(tableView.rx.items) { tableView, row, item in

            if (item.news?.gallary_image_count ?? 0) > 0 {

                let cell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: UserArticleMultiImageCell.self)
                cell.item = item
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: UserArticleCell.self)
                cell.item = item
                return cell
            }
        }
        .disposed(by: rx.disposeBag)

        // 刷新状态
        viewModel.refreshOutput
        .footerRefreshState
        .drive(tableView.refreshFooter!.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
}

// MARK: - UITableViewDelegate
extension UserArticleView: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

// MARK: - JXPagerViewListViewDelegate
extension UserArticleView: JXPagerViewListViewDelegate {

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
