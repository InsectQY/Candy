//
//  ReplyCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class ReplyCommentViewController: TableViewController {

    private var comment: ShortVideoCommentItem?

    // MARK: - Lazyload
    private lazy var topView = R.nib.replyCommentTopView.firstView(owner: nil)!

    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topView.frame = CGRect(x: 0, y: 0, width: .screenWidth, height: ReplyCommentTopView.height)
        tableView.frame = CGRect(x: 0, y: ReplyCommentTopView.height, width: .screenWidth, height: view.height - ReplyCommentTopView.height)
    }

    // MARK: - convenience
    init(comment: ShortVideoCommentItem?) {
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
        tableView.refreshFooter = RefreshFooter()
        tableView.refreshFooter?.state = .noMoreData
        bindViewModel()
    }

    func bindViewModel() {

        guard let replyComment = comment?.replyComments else { return }

        Driver.just(replyComment)
        .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.commentCell.identifier,
                                  cellType: CommentCell.self)) { tableView, item, cell in
            cell.isReply = true
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        topView.count = comment?.replyComments.count
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
