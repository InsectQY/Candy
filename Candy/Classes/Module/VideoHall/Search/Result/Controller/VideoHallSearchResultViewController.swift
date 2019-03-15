//
//  VideoHallSearchResultViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/9.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class VideoHallSearchResultViewController: TableViewController {

    private var keyword: String = ""

    // MARK: - Lazyload
    private lazy var viewModel = VideoHallSearchResultViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - convenience
    convenience init(keyword: String) {
        self.init()
        self.keyword = keyword
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.title = R.string.localizable.videoHallSearchResultTitle()

        emptyDataSetDescription = R.string.localizable.videoHallSearchResultEmptyPlaceholder()
        tableView.rowHeight = VideoHallSearchResultCell.height
        tableView.register(cellType: VideoHallSearchResultCell.self)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = VideoHallSearchResultViewModel.Input(keyword: keyword,
                                                         selection: tableView.rx.modelSelected(VideoHallSearchResultList.self),
                                                         headerRefresh: tableView.refreshHeader.rx.refreshing.asDriver(),
                                                         footerRefresh: tableView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        // TableView 数据源
        output.items.drive(tableView.rx.items(cellIdentifier: VideoHallSearchResultCell.ID, cellType: VideoHallSearchResultCell.self)) { tableView, item, cell in
            cell.item = item
        }.disposed(by: rx.disposeBag)

        // 刷新状态
        output.endHeaderRefresh
        .drive(tableView.refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)

        output.endFooterRefresh
        .drive(tableView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)

        viewModel.loading
        .drive(isLoading)
        .disposed(by: rx.disposeBag)

        viewModel.error
        .drive(rx.showError)
        .disposed(by: rx.disposeBag)
    }
}
