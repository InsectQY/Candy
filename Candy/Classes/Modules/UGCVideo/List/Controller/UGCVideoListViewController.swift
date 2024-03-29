//
//  UGCVideoListViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import EmptyDataSetExtension
import Hero
import RxOptional
import UIKit

class UGCVideoListViewController: VMCollectionViewController<UGCVideoListViewModel> {
    // MARK: - init

    private var code: String = ""

    init(code: String) {
        self.code = code
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
            self?.collectionView.emptyDataSet.setConfigAndRun(EmptyDataSetConfig(detail: R.string.localizable.videoHallSearchResultEmptyPlaceholder().emptyDataSetDescAttributed,
                                                                                 image: R.image.hg_defaultError()))
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.input.codeOb.onNext(code)

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
        if let config = collectionView.emptyDataSet.config {
            config.rx.didTapView
                .bind(to: rx.post(name: .UGCVideoNoConnectClick))
                .disposed(by: rx.disposeBag)
        }
    }
}
