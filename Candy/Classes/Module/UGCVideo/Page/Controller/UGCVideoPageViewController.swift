//
//  UGCVideoPageViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UGCVideoPageViewController: ViewController {

    private let menuH: CGFloat = 44
    private let menuW: CGFloat = ScreenWidth * 0.8

    // MARK: - LazyLoad
    fileprivate lazy var categoryView: UGCVideoTitleView = {

        let categoryView = UGCVideoTitleView(frame: CGRect(x: 0, y: 0, width: menuW, height: menuH))
        categoryView.delegate = self
        categoryView.contentScrollView = listContainerView.scrollView
        return categoryView
    }()

    // swiftlint:disable force_unwrapping
    fileprivate lazy var listContainerView = JXCategoryListContainerView(delegate: self)!

    private lazy var viewModel = UGCVideoPageViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listContainerView.frame = view.bounds
    }

    override func makeUI() {
        super.makeUI()

        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: menuW, height: menuH))
        customView.addSubview(categoryView)
        navigationItem.leftBarButtonItem = BarButtonItem(customView: customView)
        view.addSubview(listContainerView)
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.transform(input: UGCVideoPageViewModel.Input())

        viewModel.category.asDriver()
        .drive(rx.category)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension UGCVideoPageViewController: JXCategoryListContainerViewDelegate {

    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return viewModel.category.value.count
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        let category = viewModel.category.value[index].category
        return category == "ugc_video_activity" ? UGCVideoActivityListViewController(style: .plain) : UGCVideoListViewController(category: category)
    }
}

// MARK: - JXCategoryViewDelegate
extension UGCVideoPageViewController: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {

        NotificationCenter.default
        .post(name: Notification.pageDidScroll, object: nil)

        listContainerView.didClickSelectedItem(at: index)
    }

    func categoryView(_ categoryView: JXCategoryBaseView!, scrollingFromLeftIndex leftIndex: Int, toRightIndex rightIndex: Int, ratio: CGFloat) {
        listContainerView.scrolling(fromLeftIndex: leftIndex, toRightIndex: rightIndex, ratio: ratio, selectedIndex: categoryView.selectedIndex)
    }
}

extension Reactive where Base: UGCVideoPageViewController {

    var category: Binder<[VideoCategory]> {

        return Binder(base) { vc, result in

            vc.categoryView.titles = result.map { $0.name }
            vc.categoryView.defaultSelectedIndex = 0
            vc.listContainerView.defaultSelectedIndex = 0
            vc.categoryView.reloadData()
            vc.listContainerView.reloadData()
        }
    }
}
