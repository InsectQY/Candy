//
//  UGCVideoCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class UGCVideoCommentViewController: ViewController {

    private var item: UGCVideoListModel?

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: TableView! {
        didSet {

            tableView.register(cellType: CommentCell.self)
            tableView.refreshHeader = RefreshHeader()
            tableView.refreshFooter = RefreshFooter()
        }
    }
    @IBOutlet private weak var closeBtn: Button!
    @IBOutlet private weak var commentCountLabel: Label! {
        didSet {

            guard let count = item?.video?.raw_data.action.comment_count else { return }
            commentCountLabel.text = "\(count)条评论"
        }
    }

    // MARK: - Lazyload
    private lazy var viewModel = UGCVideoCommentViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - init
    init(item: UGCVideoListModel?) {
        super.init(nibName: nil, bundle: nil)
        self.item = item
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {

        super.makeUI()
        tableView.refreshHeader.beginRefreshing()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoCommentViewModel.Input(groupID: item?.video?.raw_data.group_id ?? "",
                                                   headerRefresh: tableView.refreshHeader.rx.refreshing.asDriver(),
                                                   footerRefresh: tableView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        closeBtn.rx.tap
        .bind(to: rx.dismiss())
        .disposed(by: rx.disposeBag)

        output.items.drive(tableView.rx.items(cellIdentifier: CommentCell.ID, cellType: CommentCell.self)) { tableView, item, cell in
            cell.isUGCVideo = true
            cell.item = item.comment
        }.disposed(by: rx.disposeBag)

        // 刷新状态
        output.endHeaderRefresh
        .drive(tableView.refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)

        output.endFooterRefresh
        .drive(tableView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}
