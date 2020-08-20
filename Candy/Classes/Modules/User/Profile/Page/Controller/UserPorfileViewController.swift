//
//  UserPorfileViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/2.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserPorfileViewController: VMViewController<UserPorfileViewModel> {

    private let menuH: CGFloat = 44

    private var userID: String = ""

    private var dataSource: [JXPagerViewListViewDelegate] = []

    // MARK: - Lazyload
    private lazy var headerView = R.nib.userProfileHeaderView.firstView(owner: nil)!

    private lazy var categoryView: JXCategoryTitleView = {

        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = .main
        let categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: menuH))
        categoryView.titleColor = .black
        categoryView.titleSelectedColor = .main
        categoryView.contentScrollView = pagingView?.listContainerView.collectionView
        categoryView.indicators = [lineView]
        categoryView.titles = ["小视频"]
        return categoryView
    }()

    private lazy var pagingView = JXPagerView(delegate: self)

    // MARK: - LifeCylce
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView?.frame = view.bounds
        headerView.frame = CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: 100)
    }

    // MARK: - init
    init(userID: String) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
        self.viewModel = UserPorfileViewModel()
        dataSource = [UserUGCVideoView(visitedID: "")]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //  swiftlint:disable force_unwrapping
    override func makeUI() {
        super.makeUI()

        navigationController?.navigationBar.isTranslucent = false
        view.addSubview(pagingView!)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = UserPorfileViewModel.Input(userID: userID)
        let output = viewModel.transform(input: input)

        // 用户简介
        output.userProfile
        .drive(headerView.rx.item)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - JXPagerViewDelegate
extension UserPorfileViewController: JXPagerViewDelegate {

    func tableHeaderViewHeight(in pagerView: JXPagerView!) -> UInt {
        100
    }

    func tableHeaderView(in pagerView: JXPagerView!) -> UIView! {
        headerView
    }

    func heightForPinSectionHeader(in pagerView: JXPagerView!) -> UInt {
        UInt(menuH)
    }

    func viewForPinSectionHeader(in pagerView: JXPagerView!) -> UIView! {
        categoryView
    }

    func listViews(in pagerView: JXPagerView!) -> [JXPagerViewListViewDelegate]! {
        dataSource
    }
}
