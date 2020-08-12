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
    fileprivate lazy var categoryView: JXCategoryTitleView = {

        let lineView = JXCategoryIndicatorLineView()
        lineView.lineStyle = .normal
        let categoryView = JXCategoryTitleView()
        categoryView.contentScrollView = listContainerView.scrollView
        categoryView.indicators = [lineView]
        categoryView.delegate = self
        return categoryView
    }()

    // swiftlint:disable force_unwrapping
    fileprivate lazy var listContainerView = JXCategoryListContainerView(type: .scrollView, delegate: self)!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindViewModel() {
        super.bindViewModel()

        let noConnectTap = NotificationCenter.default.rx
            .notification(Notification.videoNoConnectClick)
            .mapToVoid()
        viewModel.transform(input: VideoPageViewModel.Input(noConnectTap: noConnectTap))

        // 分类数据
        viewModel.category
        .asDriver()
        .drive(rx.category)
        .disposed(by: rx.disposeBag)
    }

    override func makeUI() {
        super.makeUI()

        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        view.addSubview(categoryView)
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryView.frame = CGRect(x: 0, y: 0, width: view.width, height: menuH)
        listContainerView.frame = CGRect(x: 0, y: menuH, width: view.width, height: view.height)
    }
}

// MARK: - JXCategoryViewDelegate
extension VideoPageViewController: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {

        NotificationCenter.default
        .post(name: Notification.pageDidScroll, object: nil)

        listContainerView.didClickSelectedItem(at: index)
    }
}

// MARK: - JXCategoryListContainerViewDelegate
extension VideoPageViewController: JXCategoryListContainerViewDelegate {

    func number(ofListsInlistContainerView listContainerView: JXCategoryListContainerView!) -> Int {
        return viewModel.category.value.count
    }

    func listContainerView(_ listContainerView: JXCategoryListContainerView!, initListFor index: Int) -> JXCategoryListContentViewDelegate! {
        return VideoListViewController(category: viewModel.category.value[index].category)
    }
}

extension Reactive where Base: VideoPageViewController {

    var category: Binder<[VideoCategory]> {

        Binder(base) { vc, result in

            vc.categoryView.titles = result.map(\.name)
            vc.categoryView.defaultSelectedIndex = 0
            vc.listContainerView.setDefaultSelectedIndex(0)
            vc.categoryView.reloadData()
            vc.listContainerView.reloadData()
        }
    }
}
