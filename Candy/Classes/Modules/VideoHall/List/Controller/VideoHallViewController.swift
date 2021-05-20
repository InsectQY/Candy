//
//  VideoHallViewController.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallViewController: VMCollectionViewController<VideoHallViewModel> {

    // MARK: - Lazyload
    private lazy var topView = TopView(frame: CGRect(x: 0,
                                                     y: topH,
                                                     width: .screenWidth,
                                                     height: 44))

    private lazy var topH = (navigationController?.navigationBar.height ?? 0) + UIApplication.shared.statusBarFrame.size.height

    /// 搜索框
    private lazy var titleView = SearchTitleView(frame: CGRect(x: SearchTitleView.x,
                                                               y: SearchTitleView.y,
                                                               width: SearchTitleView.width,
                                                               height: SearchTitleView.height))

    /// 添加到 collectionView 上的
    private lazy var filterView: FilterView = {

        let filterView = FilterView(frame: .zero)
        filterView.delegate = self
        return filterView
    }()

    /// 添加到 view 上的
    private lazy var animateFilterView: FilterView = {

        let animateFilterView = FilterView(frame: .zero)
        animateFilterView.isHidden = true
        animateFilterView.delegate = self
        return animateFilterView
    }()

    private var filterViewHeight: CGFloat = 0

    init() {
        super.init(collectionViewLayout: VideoHallFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animateFilterView.frame = CGRect(x: 0,
                                         y: -filterViewHeight,
                                         width: .screenWidth,
                                         height: filterViewHeight)
        filterView.frame = CGRect(x: 0,
                                  y: -filterViewHeight,
                                  width: .screenWidth,
                                  height: filterViewHeight)
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = titleView

        collectionView.register(R.nib.videoHallListCell)
        collectionView.refreshFooter = RefreshFooter()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        view.addSubview(topView)
        view.addSubview(animateFilterView)
        collectionView.addSubview(filterView)
    }

    override func bindViewModel() {
        super.bindViewModel()

        titleView.beginEdit
        .asObservable()
        .subscribe(viewModel.input.searchTapOb)
        .disposed(by: rx.disposeBag)

        collectionView.rx.modelSelected(VideoHallList.self)
        .asObservable()
        .subscribe(viewModel.input.selectionOb)
        .disposed(by: rx.disposeBag)

        // 刷新
        viewModel.output
        .filterViewHeight
        .drive(rx.filterViewHeight)
        .disposed(by: rx.disposeBag)

        // 视频分类
        viewModel.output
        .categories
        .drive(filterView.rx.categories)
        .disposed(by: rx.disposeBag)

        viewModel.output
        .categories
        .drive(animateFilterView.rx.categories)
        .disposed(by: rx.disposeBag)

        // 某个分类下的数据
        viewModel.output
        .items
        .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.videoHallListCell.identifier,
                                       cellType: VideoHallListCell.self)) { _, item, cell in
            cell.item = item
        }
        .disposed(by: rx.disposeBag)

        // 点击了筛选
        topView.rx.tap
        .bind(to: rx.filterTap)
        .disposed(by: rx.disposeBag)

        collectionView.setUpEmptyDataSet()
        collectionView.emptyDataSet?.description = R.string.localizable.videoHallFilterResultEmptyPlaceholder()
        collectionView.emptyDataSet?.verticalOffset = topH + 180
    }

    func filterTap() {

        animateFilterView.isHidden = false
        UIView.animate(withDuration: 0.35) { [self] in
            topView.alpha = 0
            animateFilterView.y = self.topH
        }
    }

    func setFilterViewHeight(_ height: CGFloat) {
        filterViewHeight = height
        collectionView.contentInset = UIEdgeInsets(top: height,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        viewDidLayoutSubviews()
    }
}

// MARK: - FilterViewProtocol
extension VideoHallViewController: FilterViewProtocol {

    func filterView(_ filterView: FilterView, didSelectAt row: Int, item: Int) {
        if filterView == self.filterView {
            animateFilterView.selItem(row: row, item: item)
        } else {
            self.filterView.selItem(row: row, item: item)
        }
    }

    func searchKey(_ key: String) {
        viewModel.input.searchKeyOb.onNext(key)
    }
}

// MARK: - UICollectionViewDelegate
extension VideoHallViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let height = filterViewHeight
        let contentOffsetY = scrollView.contentOffset.y + height + topH
        filterView.y = -height + contentOffsetY - contentOffsetY * 0.3
        topView.alpha = scrollView.contentOffset.y <= (-height - topH) ? 0 : scrollView.contentOffset.y / contentOffsetY * 2
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        animateFilterView.isHidden = true
        animateFilterView.y = -filterViewHeight
    }
}
