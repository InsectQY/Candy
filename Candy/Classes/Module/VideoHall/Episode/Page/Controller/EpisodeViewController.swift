//
//  EpisodeViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/27.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class EpisodeViewController: ViewController {

    /// 总共有多少集
    public var totalCount: Int = 0
    /// 当前选中的集
    private var selIndex: Int = 0
    /// 每页最多显示的集数
    private let maxPageCount = 50

    // MARK: - IBOutlet
    @IBOutlet private weak var closeBtn: Button!
    @IBOutlet private weak var categoryContentView: View!
    @IBOutlet private weak var pageContentView: View!

    private var titles: [String] = []
    private var childVcs: [EpisodeListViewController] = []

    // MARK: - Lazyload
    private lazy var categoryView: JXCategoryTitleView = {

        let lineView = JXCategoryIndicatorLineView()
        lineView.lineStyle = .JD
        lineView.indicatorLineViewColor = .main
        lineView.indicatorLineWidth = 10
        let categoryView = JXCategoryTitleView(frame: .zero)
        categoryView.delegate = self
        categoryView.titleSelectedColor = .main
        categoryView.indicators = [lineView]
        categoryView.isAverageCellSpacingEnabled = false
        return categoryView
    }()

    // swiftlint:disable force_unwrapping
    private lazy var listContainerView = JXCategoryListContainerView(delegate: self)!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

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

        // 一共有多少页
        let page = totalCount / maxPageCount
        // 最后一页到多少集(比如一共 120集 120 % 50 = 20)
        let lastPageCount = totalCount % maxPageCount

        if page == 0 { // 总集数少于最大集 (比如一共49集 49 / 50 = 0)

            titles.append("\(1)-\(lastPageCount)")
            childVcs.append(EpisodeListViewController(page: EpisodePage(start: 0, end: lastPageCount, selIndex: selIndex)))
        } else { // 总数大于最大集

            // 刚好被最大集整除 (比如一共 100集 100 / 50 = 2)
            for i in 0..<page {

                let start = i * maxPageCount
                let end = (i + 1) * maxPageCount
                titles.append("\(start + 1)-\(end)")
                childVcs.append(EpisodeListViewController(page: EpisodePage(start: start, end: end, selIndex: selIndex)))
            }

            // 大于最大集但是有余数
            guard lastPageCount > 0 else { return }

            let start = page * maxPageCount
            let end = start + lastPageCount
            // 只有一集
            let title = (start + 1) == end ? "\(start + 1)" : "\(start + 1)-\(end)"
            titles.append(title)
            childVcs.append(EpisodeListViewController(page: EpisodePage(start: start, end: end, selIndex: selIndex)))
        }

        categoryView.titles = titles
        categoryView.contentScrollView = listContainerView.scrollView
        categoryView.reloadData()
        listContainerView.reloadData()
    }

    override func bindViewModel() {
        super.bindViewModel()

        closeBtn.rx.tap
        .bind(to: rx.dismiss())
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - JXCategoryViewDelegate
extension EpisodeViewController: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        listContainerView.didClickSelectedItem(at: index)
    }

    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        listContainerView.scrolling(fromLeftIndex: leftIndex,
                                    toRightIndex: rightIndex,
                                    ratio: ratio,
                                    selectedIndex: categoryView.selectedIndex)
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension EpisodeViewController: JXCategoryListContainerViewDelegate {

    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return childVcs.count
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return childVcs[index]
    }
}
