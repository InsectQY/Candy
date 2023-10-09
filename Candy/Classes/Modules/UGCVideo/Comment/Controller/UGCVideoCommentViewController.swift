//
//  UGCVideoCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
import EmptyDataSetExtension

class UGCVideoCommentViewController: VMTableViewController<UGCVideoCommentViewModel> {

    private var id: String?
    private var commentCount: Int?

    // MARK: - LazyLoad
    private lazy var headerView = R.nib.ugcVideoCommentHeaderView.firstView(withOwner: nil)!

    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: .screenWidth,
                                  height: UGCVideoCommentHeaderView.height)
        tableView.frame = CGRect(x: 0,
                                 y: UGCVideoCommentHeaderView.height,
                                 width: .screenWidth,
                                 height: view.height - UGCVideoCommentHeaderView.height)
    }

    // MARK: - init
    init(id: String?, commentCount: Int?) {
        super.init(style: .plain)
        self.id = id
        self.commentCount = commentCount
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        view.addSubview(headerView)
        tableView.register(R.nib.commentCell)
        tableView.refreshHeader = RefreshHeader()
        tableView.delegate = self

        let config = EmptyDataSetConfig(detail: R.string.localizable.videoHallSearchResultEmptyPlaceholder().emptyDataSetDescAttributed,
                                        image: R.image.hg_defaultError())
        tableView.refreshHeader?.beginRefreshing { [weak self] in
            self?.tableView.emptyDataSet.setConfig(config)
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoCommentViewModel.Input(id: id ?? "")
        let output = viewModel.transform(input: input)

        output.items
        .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.commentCell.identifier,
                                  cellType: CommentCell.self)) { _, item, cell in
            cell.ugcComment = item
        }
        .disposed(by: rx.disposeBag)

        output.items.drive { [weak self] in
            self?.headerView.count = $0.count
        }
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension UGCVideoCommentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.fd_heightForCell(withIdentifier: R.reuseIdentifier.commentCell.identifier,
                                   cacheBy: indexPath,
                                   configuration: nil)
    }
}
