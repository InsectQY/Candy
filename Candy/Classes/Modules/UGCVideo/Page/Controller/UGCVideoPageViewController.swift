//
//  UGCVideoPageViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UGCVideoPageViewController: VMViewController<UGCVideoPageViewModel> {

    // MARK: - LazyLoad
    private lazy var categoryView: UGCVideoTitleView = {

        let categoryView = UGCVideoTitleView(frame: .zero)
        categoryView.delegate = self
        categoryView.listContainer = listContainerView
        return categoryView
    }()

    // swiftlint:disable:next force_unwrapping
    private lazy var listContainerView = JXCategoryListContainerView(type: .scrollView,
                                                                     delegate: self)!

    // MARK: - LifeCycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryView.frame = CGRect(x: 0, y: 0, width: .screenWidth, height: 44)
        listContainerView.frame = CGRect(x: 0,
                                         y: .navigationBarBottomY,
                                         width: .screenWidth,
                                         height: .screenHeight - .navigationBarBottomY - .tabBarHeight)
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = categoryView
        view.addSubview(listContainerView)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UGCVideoPageViewModel.Input(emptyDataSetViewTap: NotificationCenter.default.rx
            .notification(.UGCVideoNoConnectClick)
            .mapToVoid())
        viewModel.transform(input: input)

        viewModel.category
        .mapMany(\.name)
        .asDriverOnErrorJustComplete()
        .drive(categoryView.rx.titles)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension UGCVideoPageViewController: JXCategoryListContainerViewDelegate {

    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        viewModel.category.value.count
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        UGCVideoListViewController(code: viewModel.category.value[index].code)
    }
}

// MARK: - JXCategoryViewDelegate
extension UGCVideoPageViewController: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {

        NotificationCenter.default
        .post(name: .pageDidScroll, object: nil)

        listContainerView.didClickSelectedItem(at: index)
    }
}
