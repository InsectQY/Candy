//
//  CollectionViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

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

        isLoading.asDriver()
        .distinctUntilChanged()
        .mapToVoid()
        .drive(rx.reloadEmptyDataSet)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 设置 DZNEmptyDataSet
    func setUpEmptyDataSet() {
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
}

// MARK: - Refreshable
extension CollectionViewController: Refreshable {

    var header: ControlEvent<Void> {
        return collectionView.refreshHeader.rx.refreshing
    }

    var footer: ControlEvent<Void> {
        return collectionView.refreshFooter.rx.refreshing
    }
}

// MARK: - Refresh
extension CollectionViewController {

    func beginHeaderRefresh() {
        collectionView.refreshHeader.beginRefreshing { [weak self] in
            self?.setUpEmptyDataSet()
        }
    }

    func bindHeaderRefresh(with state: Observable<Bool>) {
        state
        .bind(to: collectionView.refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)
    }

    func bindFooterRefresh(with state: Observable<RxMJRefreshFooterState>) {
        state
        .bind(to: collectionView.refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - Reactive-extension
extension Reactive where Base: CollectionViewController {

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
