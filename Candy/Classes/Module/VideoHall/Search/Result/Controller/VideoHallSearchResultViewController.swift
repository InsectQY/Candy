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
    private lazy var viewModel = VideoHallSearchResultViewModel(input: self)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - convenience
    init(keyword: String) {
        self.keyword = keyword
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
                                                         selection: tableView.rx.modelSelected(VideoHallSearchResultList.self))
        let output = viewModel.transform(input: input)

        // TableView 数据源
        output.items.drive(tableView.rx.items(cellIdentifier: VideoHallSearchResultCell.ID, cellType: VideoHallSearchResultCell.self)) { tableView, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        // 显示 error
        bindErrorToShowToast(viewModel.error)
    }
}
