//
//  UGCVideoListViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import Hero

class UGCVideoListViewController: VMCollectionViewController<UGCVideoListViewModel> {

    // MARK: - init
    init() {
        super.init(collectionViewLayout: UGCVideoListFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        collectionView.register(R.nib.ugcVideoListCell)
        collectionView.refreshHeader = RefreshHeader()
        collectionView.refreshFooter = RefreshFooter()
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        collectionView.rx.itemSelected
        .asDriver()
        .drive(viewModel.input.selectionOb)
        .disposed(by: rx.disposeBag)

        viewModel.output
        .items
        .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.ugcVideoListCell.identifier,
                                       cellType: UGCVideoListCell.self)) { collectionView, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        // 数据源 nil 时点击
        rx.emptyDataSetDidTapView()
        .bind(to: rx.post(name: Notification.UGCVideoNoConnectClick))
        .disposed(by: rx.disposeBag)
    }
}
