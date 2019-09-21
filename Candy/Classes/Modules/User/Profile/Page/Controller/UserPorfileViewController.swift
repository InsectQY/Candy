//
//  UserPorfileViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/2.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import JXCategoryView

class UserPorfileViewController: ViewController<UserPorfileViewModel> {

    private let menuH: CGFloat = 44

    private var userID: String = ""

    fileprivate var dataSource: [JXPagerViewListViewDelegate] = []

    // MARK: - Lazyload
    fileprivate lazy var headerView = R.nib.userProfileHeaderView.firstView(owner: nil)!

    fileprivate lazy var categoryView: JXCategoryTitleView = {

        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorColor = .main
        let categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: menuH))
        categoryView.titleColor = .black
        categoryView.titleSelectedColor = .main
        categoryView.contentScrollView = pagingView?.listContainerView.collectionView
        categoryView.indicators = [lineView]
        return categoryView
    }()

    fileprivate lazy var pagingView = JXPagerView(delegate: self)

    // MARK: - LifeCylce
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pagingView?.frame = view.bounds
        headerView.frame = CGRect(x: 0, y: 0, width: Configs.Dimensions.screenWidth, height: 200)
    }

    // MARK: - init
    init(userID: String) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
        self.viewModel = UserPorfileViewModel()
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
        .drive(rx.userProfile)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - JXPagerViewDelegate
extension UserPorfileViewController: JXPagerViewDelegate {

    func tableHeaderViewHeight(in pagerView: JXPagerView!) -> UInt {
        return 200
    }

    func tableHeaderView(in pagerView: JXPagerView!) -> UIView! {
        return headerView
    }

    func heightForPinSectionHeader(in pagerView: JXPagerView!) -> UInt {
        return UInt(menuH)
    }

    func viewForPinSectionHeader(in pagerView: JXPagerView!) -> UIView! {
        return categoryView
    }

    func listViews(in pagerView: JXPagerView!) -> [JXPagerViewListViewDelegate]! {
        return dataSource
    }
}

// MARK: - Reactive-Extension
extension Reactive where Base: UserPorfileViewController {

    var userProfile: Binder<UserProfileModel> {
        return Binder(base) { vc, result in

            vc.navigationItem.title = result.name
            vc.categoryView.titles = result.top_tab.map { $0.show_name }
            vc.dataSource = result.top_tab.map {
                $0.type.viewWith(category: $0.category,
                                 visitedID: result.user_id)
            }
            vc.categoryView.reloadData()
            vc.pagingView?.reloadData()
            vc.headerView.item = result
        }
    }
}
