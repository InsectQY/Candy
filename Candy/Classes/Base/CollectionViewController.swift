//
//  CollectionViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

/// 继承时需指定 RefreshViewModel 或其子类作为泛型。
/// 该类实现 UICollectionView 的 header / footer 刷新逻辑。
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

    /// 子类调用 super.bindViewModel 会自动创建 viewModel 对象。
    /// 如果不需要自动创建 viewModel，不调用 super 即可。
    override func bindViewModel() {
        super.bindViewModel()

        bindReloadEmpty()
        bindHeader()
        bindFooter()
        viewModel.bindState()
    }

    // MARK: - 开始头部刷新
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

    // MARK: - 绑定头部刷新回调和头部刷新状态
    func bindHeader() {

        guard
            let refreshHeader = collectionView.refreshHeader
        else {
            return
        }

        refreshHeader.rx.refreshing
        .bind(to: viewModel.refreshInput.beginHeaderRefresh)
        .disposed(by: rx.disposeBag)

        viewModel
        .refreshOutput
        .headerRefreshState
        .drive(refreshHeader.rx.isRefreshing)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定尾部刷新回调和尾部刷新状态
    func bindFooter() {

        guard
            let refreshFooter = collectionView.refreshFooter
        else {
            return
        }

        refreshFooter.rx.refreshing
        .bind(to: viewModel.refreshInput.beginFooterRefresh)
        .disposed(by: rx.disposeBag)

        viewModel
        .refreshOutput
        .footerRefreshState
        .drive(refreshFooter.rx.refreshFooterState)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定数据源 nil 的占位图
    func bindReloadEmpty() {

        viewModel.loading
        .distinctUntilChanged()
        .mapToVoid()
        .drive(collectionView.rx.reloadEmptyDataSet)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - Reactive-extension
extension Reactive where Base: CollectionViewController<RefreshViewModel> {

    var beginHeaderRefresh: Binder<Void> {

        return Binder(base) { vc, _ in
            vc.beginHeaderRefresh()
        }
    }
}
