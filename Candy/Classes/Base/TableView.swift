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

        estimatedRowHeight = 50
        rowHeight = UITableView.automaticDimension
        backgroundColor = .clear
        if #available(iOS 9.0, *) {
            cellLayoutMarginsFollowReadableWidth = false
        }
        keyboardDismissMode = .onDrag
        separatorStyle = .none
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
