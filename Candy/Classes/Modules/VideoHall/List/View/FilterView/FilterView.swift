//
//  FilterView.swift
//  BookShopkeeper
//
//  Created by QY on 2018/1/17.
//  Copyright © 2018年 dingding. All rights reserved.
//

import UIKit

public protocol FilterViewProtocol: class {

    func searchKey(_ key: String)

    func filterView(_ filterView: FilterView, didSelectAt row: Int, item: Int)
}

public class FilterView: UIView {

    public weak var delegate: FilterViewProtocol?

    private let cellID: String = "FilterCell"
    /// 已经选择的筛选数据
    private var selItems: [Filter] = [] {
        didSet {
            let key = selItems.map(\.search_key).joined(separator: ",")
            delegate?.searchKey(key)
        }
    }

    /// 所有筛选数据
    public var filter: [CategoryList] = [] {
        didSet {
            tableView.reloadData()
            // 默认选中每组第一个
            selItems = filter.compactMap(\.search_category_word_list.first)
            layoutSubviews()
        }
    }

    private lazy var tableView: UITableView = {

        let tableView = UITableView(frame: bounds)
        tableView.register(FilterCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        return tableView
    }()

    public func selItem(row: Int, item: Int) {

        guard
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FilterCell,
            item != cell.categoryView.selectedIndex
        else {
            return
        }
        cell.categoryView.selectItem(at: item)
        cell.categoryView.reloadData()
    }

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource
extension FilterView: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filter.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath,
                                                 cellType: FilterCell.self)
        cell.filter = filter[indexPath.row].search_category_word_list
        cell.filterClick = { [unowned self] in
            self.selItems[indexPath.row] = self.filter[indexPath.row].search_category_word_list[$0]
            self.delegate?.filterView(self, didSelectAt: indexPath.row, item: $0)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == (filter.count - 1) ? FilterCell.cellHeight + FilterCell.categoryViewY : FilterCell.cellHeight
    }
}
