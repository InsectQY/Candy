//
//  FilterCell.swift
//  BookShopkeeper
//
//  Created by InsectQY on 2018/4/24.
//Copyright © 2018年 dingding. All rights reserved.
//

import UIKit
import JXCategoryView

class FilterCell: TableViewCell {

    static let cellHeight: CGFloat = 40

    /// 点击回调
    var filterClick: ((Int) -> Void)?

    public lazy var categoryView: JXCategoryTitleView = {

        let backgroundView = JXCategoryIndicatorBackgroundView()
        backgroundView.backgroundViewWidthIncrement = 30
        backgroundView.backgroundViewHeight = 28
        backgroundView.backgroundViewColor = RGBA(240, 240, 240)
        let categoryView = JXCategoryTitleView()
        categoryView.indicators = [backgroundView]
        categoryView.isTitleColorGradientEnabled = false
        categoryView.isTitleLabelMaskEnabled = true
        categoryView.isAverageCellSpacingEnabled = false
        categoryView.titleSelectedColor = .main
        categoryView.cellSpacing = 30
        categoryView.delegate = self
        return categoryView
    }()

    public var filter: [Filter] = [] {

        didSet {
            categoryView.titles = filter.map { $0.name }
            categoryView.reloadData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(categoryView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        categoryView.frame = CGRect(x: 0, y: 10, width: ScreenWidth, height: bounds.height)
    }
}

// MARK: - JXCategoryViewDelegate
extension FilterCell: JXCategoryViewDelegate {

    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        filterClick?(index)
    }
}
