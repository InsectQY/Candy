//
//  UGCVideoView.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserUGCVideoView: View {

    public var scrollCallback: ((UIScrollView?) -> Void)?

    /// 分类
    private var category: String = ""
    /// 访问用户的 ID
    private var visitedID: String = ""

    // MARK: - Lazyload
    private lazy var collectionView: CollectionView = {

        let collectionView = CollectionView(frame: bounds, collectionViewLayout: UserUGCFlowLayout())
        collectionView.delegate = self
        collectionView.register(R.nib.userUGCVideoCell)
        collectionView.refreshFooter = RefreshFooter()
        return collectionView
    }()

    private lazy var viewModel = UserUGCViewModel()

    // MARK: - LifeCylce
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func makeUI() {
        super.makeUI()

        addSubview(collectionView)
    }

    //  swiftlint:disable force_unwrapping
    override func bindViewModel() {
        super.bindViewModel()

        let input = UserUGCViewModel.Input(category: category,
                                           visitedID: visitedID)
        let output = viewModel.transform(input: input)

        output.items
        .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.userUGCVideoCell.identifier,
                                       cellType: UserUGCVideoCell.self)) { collectionView, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        // 刷新状态
        viewModel.refreshOutput
        .footerRefreshState
        .drive(collectionView.refreshFooter!.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }

    convenience init(category: String, visitedID: String) {
        self.init()
        self.category = category
        self.visitedID = visitedID
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
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
