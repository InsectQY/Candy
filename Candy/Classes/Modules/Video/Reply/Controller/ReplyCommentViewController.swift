//
//  ReplyCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class ReplyCommentViewController: VMTableViewController<ReplyCommentViewModel> {

    private var comment: Comment? {
        didSet {
            topView.count = comment?.reply_count
        }
    }

    // MARK: - Lazyload
    private lazy var topView = R.nib.replyCommentTopView.firstView(owner: nil)!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topView.frame = CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: ReplyCommentTopView.height)
        tableView.frame = CGRect(x: 0, y: ReplyCommentTopView.height, width: Configs.Dimensions.screenWidth, height: view.height - ReplyCommentTopView.height)
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
        tableView.delegate = self
        tableView.register(R.nib.commentCell)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        tableView.refreshHeader?.beginRefreshing()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = ReplyCommentViewModel.Input(id: comment?.id ?? "")
        let output = viewModel.transform(input: input)

        output.items
        .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.commentCell.identifier,
                                  cellType: CommentCell.self)) { tableView, item, cell in
            cell.reply = item
        }
        .disposed(by: rx.disposeBag)
    }
}

extension ReplyCommentViewController {

    private func setUpTableHeader() {

        let headerView = R.nib.replyCommentHeader.firstView(owner: nil)!
        headerView.item = comment
        let height = headerView
        .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        .height
        headerView.height = height
        tableView.tableHeaderView = headerView
    }
}

// MARK: - UITableViewDelegate
extension ReplyCommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.fd_heightForCell(withIdentifier: R.reuseIdentifier.commentCell.identifier,
                                   cacheBy: indexPath,
                                   configuration: nil)
    }
}
