//
//  EpisodeViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class EpisodeViewController: VMViewController<EpisodePageViewModel> {

    /// 总共有多少集
    public var totalCount: Int = 0
    /// 当前选中的集
    private var selIndex: Int = 0

    // MARK: - IBOutlet
    @IBOutlet private weak var closeBtn: Button!
    @IBOutlet private weak var categoryContentView: View!
    @IBOutlet private weak var pageContentView: View!

    // MARK: - LazyLoad
    private lazy var categoryView: JXCategoryTitleView = {

        let lineView = JXCategoryIndicatorLineView()
        lineView.lineStyle = .normal
        lineView.indicatorWidth = 10
        lineView.indicatorColor = .main
        let categoryView = JXCategoryTitleView(frame: .zero)
        categoryView.delegate = self
        categoryView.titleSelectedColor = .main
        categoryView.isAverageCellSpacingEnabled = false
        categoryView.listContainer = listContainerView
        categoryView.indicators = [lineView]
        return categoryView
    }()

    // swiftlint:disable force_unwrapping
    private lazy var listContainerView = JXCategoryListContainerView(type: .scrollView,
                                                                     delegate: self)!

    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryView.frame = categoryContentView.bounds
        listContainerView.frame = pageContentView.bounds
    }

    // MARK: - init
    init(totalCount: Int, selIndex: Int) {
        self.totalCount = totalCount
        self.selIndex = selIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        categoryContentView.addSubview(categoryView)
        pageContentView.addSubview(listContainerView)
    }

    override func bindViewModel() {

        viewModel = EpisodePageViewModel(totalCount: totalCount)
        super.bindViewModel()

        closeBtn.rx.tap
        .bind(to: rx.dismiss())
        .disposed(by: rx.disposeBag)

        categoryView.titles = viewModel.output.titles
        categoryView.reloadData()
    }
}

// MARK: - JXCategoryViewDelegate
extension EpisodeViewController: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        listContainerView.didClickSelectedItem(at: index)
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension EpisodeViewController: JXCategoryListContainerViewDelegate {

    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        viewModel.output.items.count
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        EpisodeListViewController(page: viewModel.output.items[index],
                                  selIndex: selIndex)
    }
}
