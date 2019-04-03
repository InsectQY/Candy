//
//  UGCVideoCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class UGCVideoCommentViewController: TableViewController {

    private var item: UGCVideoListModel? {
        didSet {
            headerView.count = item?.video?.raw_data.action.comment_count
        }
    }

    private lazy var headerView = UGCVideoCommentHeaderView.loadFromNib()

    // MARK: - Lazyload
    private lazy var viewModel = UGCVideoCommentViewModel(input: self)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        headerView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: UGCVideoCommentHeaderView.height)
        tableView.frame = CGRect(x: 0, y: UGCVideoCommentHeaderView.height, width: ScreenWidth, height: view.height - UGCVideoCommentHeaderView.height)
    }

    // MARK: - init
    init(item: UGCVideoListModel?) {
        super.init(style: .plain)
        self.item = item
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(cellType: CommentCell.self)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoCommentViewModel.Input(groupID: item?.video?.raw_data.group_id ?? "")
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: CommentCell.ID, cellType: CommentCell.self)) { tableView, item, cell in
            cell.isUGCVideo = true
            cell.item = item.comment
        }
        .disposed(by: rx.disposeBag)

        // 刷新状态
        bindHeaderRefresh(with: viewModel.headerRefreshState)
        bindFooterRefresh(with: viewModel.footerRefreshState)

        // 加载状态
        bindLoading(with: viewModel.loading)

        // error toast
        bindErrorToShowToast(viewModel.refreshError)
    }
}
