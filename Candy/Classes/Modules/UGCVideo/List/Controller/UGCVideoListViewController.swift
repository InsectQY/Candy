//
//  UGCVideoListViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Hero
import RxOptional
import UIKit

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

        collectionView.refreshHeader?.beginRefreshing { [weak self] in
            self?.collectionView.emptyDataSet.setConfig(EmptyDataSetConfig(description: R.string.localizable.videoHallSearchResultEmptyPlaceholder().emptyDataSetDescAttributed,
                                                                           image: R.image.hg_defaultError()))
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        collectionView.rx.itemSelected
            .asDriver()
            .drive(viewModel.input.selectionOb)
            .disposed(by: rx.disposeBag)

        viewModel.output
            .items
            .filterEmpty()
            .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.ugcVideoListCell.identifier,
                                           cellType: UGCVideoListCell.self)) { _, item, cell in
                cell.item = item
            }
            .disposed(by: rx.disposeBag)

        // 数据源 nil 时点击
        collectionView.emptyDataSet.rx.didTapView()
            .bind(to: rx.post(name: .UGCVideoNoConnectClick))
            .disposed(by: rx.disposeBag)
    }
}
