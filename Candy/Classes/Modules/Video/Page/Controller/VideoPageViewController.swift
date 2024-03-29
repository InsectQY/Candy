//
//  VideoPageViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/4.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class VideoPageViewController: VMViewController<VideoPageViewModel> {

    private let menuH: CGFloat = 44

    // MARK: - LazyLoad
    private lazy var categoryView: JXCategoryTitleView = {

        let lineView = JXCategoryIndicatorLineView()
        lineView.lineStyle = .normal
        let categoryView = JXCategoryTitleView()
        categoryView.listContainer = listContainerView
        categoryView.indicators = [lineView]
        categoryView.delegate = self
        return categoryView
    }()

    // swiftlint:disable:next force_unwrapping
    private lazy var listContainerView = JXCategoryListContainerView(type: .scrollView,
                                                                     delegate: self)!

    // MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindViewModel() {
        super.bindViewModel()

        let noConnectTap = NotificationCenter.default.rx
            .notification(.videoNoConnectClick)
            .mapToVoid()
        viewModel.transform(input: VideoPageViewModel.Input(noConnectTap: noConnectTap))

        // 分类数据
        viewModel.category
        .mapMany(\.name)
        .bind(to: categoryView.rx.titles)
        .disposed(by: rx.disposeBag)
    }

    override func makeUI() {
        super.makeUI()

        view.addSubview(categoryView)
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        categoryView.frame = CGRect(x: 0,
                                    y: .navigationBarBottomY,
                                    width: view.width,
                                    height: menuH)
        listContainerView.frame = CGRect(x: 0,
                                         y: .navigationBarBottomY + menuH,
                                         width: view.width,
                                         height: view.height - .navigationBarBottomY - .tabBarTopY)
    }
}

// MARK: - JXCategoryViewDelegate
extension VideoPageViewController: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {

        NotificationCenter.default
        .post(name: .pageDidScroll, object: nil)

        listContainerView.didClickSelectedItem(at: index)
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension VideoPageViewController: JXCategoryListContainerViewDelegate {

    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        viewModel.category.value.count
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        VideoListViewController(category: viewModel.category.value[index].code)
    }
}
