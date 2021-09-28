//
//  BaseTableViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class TableViewController: ViewController {

    private var style: UITableView.Style = .plain

    // MARK: - LazyLoad
    lazy var tableView: TableView = {

        let tableView = TableView(frame: view.bounds,
                                  style: style)
        return tableView
    }()

    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - init
    init(style: UITableView.Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - override
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()
        view.addSubview(tableView)
    }
}
