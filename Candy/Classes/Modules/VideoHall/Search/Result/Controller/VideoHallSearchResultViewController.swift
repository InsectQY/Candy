//
//  VideoHallSearchResultViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/9.
//  Copyright © 2019 Insect. All rights reserved.
//

import EmptyDataSet_Swift
import UIKit

class VideoHallSearchResultViewController: VMTableViewController<VideoHallSearchResultViewModel> {
    private var keyword: String = ""

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

        tableView.rowHeight = VideoHallSearchResultCell.height
        tableView.register(R.nib.videoHallSearchResultCell)
        tableView.refreshHeader = RefreshHeader()

        tableView.emptyDataSet.setConfig(EmptyDataSetConfig(description: R.string.localizable.videoHallSearchResultEmptyPlaceholder().emptyDataSetDescAttributed,
                                                            image: R.image.hg_defaultError()))
        tableView.refreshHeader?.beginRefreshing { [weak self] in
            self?.tableView.emptyDataSet.initialize()
        }
    }

    override func bindViewModel() {
        super.bindViewModel()
        let input = VideoHallSearchResultViewModel.Input(keyword: keyword,
                                                         selection: tableView.rx.modelSelected(VideoHallSearchResultList.self))
        let output = viewModel.transform(input: input)

        // TableView 数据源
        output.items
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.videoHallSearchResultCell.identifier,
                                      cellType: VideoHallSearchResultCell.self)) { _, item, cell in
                cell.item = item
            }
            .disposed(by: rx.disposeBag)
    }
}
