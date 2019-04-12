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

// MARK: - RefreshComponent
extension CollectionViewController: RefreshComponentable {
    var header: ControlEvent<Void> {

        if let refreshHeader = collectionView.refreshHeader {
            return refreshHeader.rx.refreshing
        }
        return ControlEvent(events: Observable.empty())
    }

    var footer: ControlEvent<Void> {

        if let refreshFooter = collectionView.refreshFooter {
            return refreshFooter.rx.refreshing
        }
        return ControlEvent(events: Observable.empty())
    }
}

// MARK: - BindRefreshState
extension CollectionViewController: BindRefreshStateable {

    func bindHeaderRefresh(with state: Observable<Bool>) {

        guard let refreshHeader = collectionView.refreshHeader else { return }
        state
        .bind(to: refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)
    }

    func bindFooterRefresh(with state: Observable<RxMJRefreshFooterState>) {

        guard let refreshFooter = collectionView.refreshFooter else { return }
        state
        .bind(to: refreshFooter.rx.refreshFooterState)
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
