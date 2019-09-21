//
//  UGCVideoCommentViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class UGCVideoCommentViewController: TableViewController<UGCVideoCommentViewModel> {

    private var item: UGCVideoListModel? {
        didSet {
            headerView.count = item?.content.raw_data.action.comment_count
        }
    }

    // MARK: - Lazyload
    private lazy var headerView = R.nib.ugcVideoCommentHeaderView.firstView(owner: nil)!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        headerView.frame = CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: UGCVideoCommentHeaderView.height)
        tableView.frame = CGRect(x: 0, y: UGCVideoCommentHeaderView.height, width: Configs.Dimensions.screenWidth, height: view.height - UGCVideoCommentHeaderView.height)
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

        view.addSubview(headerView)
        tableView.register(R.nib.commentCell)
        tableView.refreshHeader = RefreshHeader()
        tableView.refreshFooter = RefreshFooter()
        tableView.delegate = self
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoCommentViewModel.Input(groupID: item?.content.raw_data.group_id ?? "")
        let output = viewModel.transform(input: input)

        output.items
        .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.commentCell.identifier,
                                  cellType: CommentCell.self)) { tableView, item, cell in
            cell.isUGCVideo = true
            cell.item = item.comment
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
