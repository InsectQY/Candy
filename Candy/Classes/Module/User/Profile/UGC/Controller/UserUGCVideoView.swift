//
//  UGCVideoView.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserUGCVideoView: UIView {

    public var scrollCallback: ((UIScrollView?) -> Void)?

    /// 分类
    private var category: String = ""
    /// 访问用户的 ID
    private var visitedID: String = ""

    // MARK: - Lazyload
    private lazy var collectionView: CollectionView = {

        let collectionView = CollectionView(frame: bounds, collectionViewLayout: UserUGCFlowLayout())
        collectionView.delegate = self
        collectionView.register(cellType: UserUGCVideoCell.self)
        collectionView.refreshFooter = RefreshFooter()
        return collectionView
    }()

    private lazy var viewModel = UserUGCViewModel()

    // MARK: - LifeCylce
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(category: String, visitedID: String) {
        self.init()
        self.category = category
        self.visitedID = visitedID
        makeUI()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
}

extension UserUGCVideoView {

    private func makeUI() {
        addSubview(collectionView)
    }

    private func bindViewModel() {

        let input = UserUGCViewModel.Input(category: category,
                                           visitedID: visitedID,
                                           footerRefresh: collectionView.refreshFooter.rx.refreshing.asDriver())
        let output = viewModel.transform(input: input)

        output.items.drive(collectionView.rx.items(cellIdentifier: UserUGCVideoCell.ID, cellType: UserUGCVideoCell.self)) { collectionView, item, cell in
            cell.item = item
        }.disposed(by: rx.disposeBag)

        // 刷新状态
        output.endFooterRefresh
        .drive(collectionView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - UICollectionViewDelegate
extension UserUGCVideoView: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

// MARK: - JXPagerViewListViewDelegate
extension UserUGCVideoView: JXPagerViewListViewDelegate {

    func listView() -> UIView! {
        return self
    }

    func listScrollView() -> UIScrollView! {
        return collectionView
    }

    func listViewDidScrollCallback(_ callback: ((UIScrollView?) -> Void)!) {
        scrollCallback = callback
    }
}
