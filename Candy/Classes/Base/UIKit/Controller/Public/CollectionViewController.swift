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

        let collectionView = CollectionView(frame: view.bounds,
                                            collectionViewLayout: layout)
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
}
