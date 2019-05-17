//
//  ReplyCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class ReplyCommentViewController: TableViewController<ReplyCommentViewModel> {

    private var comment: Comment? {
        didSet {
            topView.count = comment?.reply_count
        }
    }

    // MARK: - Lazyload
    private lazy var topView = ReplyCommentTopView.loadFromNib()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ReplyCommentTopView.height)
        tableView.frame = CGRect(x: 0, y: ReplyCommentTopView.height, width: ScreenWidth, height: view.height - ReplyCommentTopView.height)
    }

    // MARK: - convenience
    init(comment: Comment?) {
        super.init(style: .plain)
        self.comment = comment
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        view.addSubview(topView)
        setUpTableHeader()
        tableView.register(cellType: CommentCell.self)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        tableView.refreshHeader?.beginRefreshing()
    }

    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = viewModel else { return }

        let input = ReplyCommentViewModel.Input(id: comment?.id ?? "")
        let output = viewModel.transform(input: input)

        output.items.drive(tableView.rx.items(cellIdentifier: CommentCell.ID, cellType: CommentCell.self)) { tableView, item, cell in
            cell.reply = item
        }
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
