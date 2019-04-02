//
//  UGCVideoListViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import Hero
import JXCategoryView

class UGCVideoListViewController: CollectionViewController {

    /// 视频类型
    private var category: String = ""

    // MARK: - Lazyload
    private lazy var viewModel = UGCVideoListViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - init
    init(category: String) {
        self.category = category
        super.init(collectionViewLayout: UGCVideoListFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {

        super.makeUI()
        collectionView.register(cellType: UGCVideoListCell.self)
        collectionView.refreshHeader = RefreshHeader()
        collectionView.refreshFooter = RefreshFooter()
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoListViewModel.Input(category: category,
                                                selection: collectionView.rx.itemSelected.asDriver(),
                                                headerRefresh: collectionView.refreshHeader.rx.refreshing.asDriver(),
                                                footerRefresh: collectionView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(collectionView.rx.items) { collectionView, row, item in

            let cell = collectionView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: UGCVideoListCell.self)
            cell.coverImage.hero.id = "image_\(row)"
            cell.item = item
            return cell
        }
        .disposed(by: rx.disposeBag)

        // 没有网络时点击
        noConnectionViewTap
        .bind(to: rx.postNotification)
        .disposed(by: rx.disposeBag)

        // 刷新状态
        output.endHeaderRefresh
        .drive(collectionView.refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)

        output.endFooterRefresh
        .drive(collectionView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}
