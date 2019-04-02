//
//  ReplyCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class ReplyCommentViewController: ViewController {

    private var comment: Comment?

    // MARK: - IBOutlet
    @IBOutlet private weak var commentCountLabel: Label! {
        didSet {
            commentCountLabel.text = "\(comment?.reply_count ?? 0)条回复"
        }
    }
    @IBOutlet private weak var closeBtn: Button!
    @IBOutlet private weak var tableView: TableView! {
        didSet {

            tableView.register(cellType: CommentCell.self)
            tableView.refreshHeader = RefreshHeader()
            tableView.refreshFooter = RefreshFooter()
            setUpTableHeader()
        }
    }

    // MARK: - Lazyload
    private lazy var viewModel = ReplyCommentViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - convenience
    convenience init(comment: Comment?) {
        self.init()
        self.comment = comment
    }

    override func makeUI() {

        super.makeUI()
        tableView.refreshHeader.beginRefreshing()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = ReplyCommentViewModel.Input(id: comment?.id ?? "",
                                                headerRefresh: tableView.refreshHeader.rx.refreshing.asDriver(),
                                                footerRefresh: tableView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        closeBtn.rx.tap
        .bind(to: rx.dismiss())
        .disposed(by: rx.disposeBag)

        output.items.drive(tableView.rx.items(cellIdentifier: CommentCell.ID, cellType: CommentCell.self)) { tableView, item, cell in
            cell.reply = item
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

extension ReplyCommentViewController {

    private func setUpTableHeader() {

        let headerView = ReplyCommentHeader.loadFromNib()
        headerView.item = comment
        let height = headerView
        .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        .height
        headerView.height = height
        tableView.tableHeaderView = headerView
    }
}
