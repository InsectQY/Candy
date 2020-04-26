//
//  BaseTableView.swift
//  SSDispatch
//
//  Created by insect_qy on 2018/8/20.
//  Copyright © 2018年 insect_qy. All rights reserved.
//

import UIKit

class TableView: UITableView {

    init() {
        super.init(frame: CGRect(), style: .grouped)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        rowHeight = UITableView.automaticDimension
        backgroundColor = .clear
        if #available(iOS 11.0, *) {
            estimatedRowHeight = 0
            estimatedSectionHeaderHeight = 0
            estimatedSectionFooterHeight = 0
        }
        keyboardDismissMode = .onDrag
        separatorStyle = .none
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
