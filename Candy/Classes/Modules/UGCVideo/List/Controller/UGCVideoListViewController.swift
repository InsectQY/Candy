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

class UGCVideoListViewController: CollectionViewController<UGCVideoListViewModel> {

    /// 视频类型
    private var category: String = ""

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

        collectionView.register(R.nib.ugcVideoListCell)
        collectionView.refreshHeader = RefreshHeader()
        collectionView.refreshFooter = RefreshFooter()
        beginHeaderRefresh()
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel
        .input
        .category
        .onNext(category)

        collectionView.rx.itemSelected
        .asDriver()
        .drive(viewModel.input.selection)
        .disposed(by: rx.disposeBag)

        viewModel.output.items
        .drive(collectionView.rx.items) { collectionView, row, item in

            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ugcVideoListCell.identifier,
                                                          for: indexPath,
                                                          cellType: UGCVideoListCell.self)
            cell.coverImage.hero.id = "image_\(row)"
            cell.item = item
            return cell
        }
        .disposed(by: rx.disposeBag)

        // 没有网络时点击
        noConnectionViewTap
        .bind(to: rx.post(name: Notification.UGCVideoNoConnectClick))
        .disposed(by: rx.disposeBag)
    }
}
