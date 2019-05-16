//
//  CollectionViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class CollectionViewController<RVM: RefreshViewModel>: ViewController<RVM> {

    private var layout: UICollectionViewLayout = UICollectionViewLayout()
    // MARK: - Lazyload
    lazy var collectionView: CollectionView = {

        let collectionView = CollectionView(frame: view.bounds, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: - init
    init(collectionViewLayout layout: UICollectionViewLayout) {
        self.layout = layout
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - override
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        view.addSubview(collectionView)
    }

    override func bindViewModel() {
        super.bindViewModel()

//        isLoading.asDriver()
//        .distinctUntilChanged()
//        .mapToVoid()
//        .drive(rx.reloadEmptyDataSet)
//        .disposed(by: rx.disposeBag)

        guard let viewModel = viewModel else { return }

        if let refreshHeader = collectionView.refreshHeader {

            refreshHeader.rx.refreshing
            .bind(to: viewModel.refreshInput.beginHeaderRefresh)
            .disposed(by: rx.disposeBag)

            viewModel.refreshOutput.headerRefreshState
            .drive(refreshHeader.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        }

        if let refreshFooter = collectionView.refreshFooter {

            refreshFooter.rx.refreshing
            .bind(to: viewModel.refreshInput.beginFooterRefresh)
            .disposed(by: rx.disposeBag)

            viewModel.refreshOutput.footerRefreshState
            .drive(refreshFooter.rx.refreshFooterState)
            .disposed(by: rx.disposeBag)
        }
    }

    func beginHeaderRefresh() {
        collectionView.refreshHeader?.beginRefreshing { [weak self] in
            self?.setUpEmptyDataSet()
        }
    }

    // MARK: - 设置 DZNEmptyDataSet
    func setUpEmptyDataSet() {
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
}

// MARK: - Reactive-extension
extension Reactive where Base: CollectionViewController<RefreshViewModel> {

    var reloadEmptyDataSet: Binder<Void> {

        return Binder(base) { vc, _ in
            vc.collectionView.reloadEmptyDataSet()
        }
    }

    var beginHeaderRefresh: Binder<Void> {

        return Binder(base) { vc, _ in
            vc.beginHeaderRefresh()
        }
    }
}
