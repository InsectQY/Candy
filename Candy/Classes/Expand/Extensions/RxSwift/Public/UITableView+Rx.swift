//
//  UITableView+Rx.swift
//  Candy
//
//  Created by QY on 2019/5/19.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension Reactive where Base: UITableView {

    var reloadData: Binder<Void> {

        Binder(base) { tableView, _ in
            tableView.reloadData()
        }
    }

    func scrollToRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Binder<IndexPath> {

        Binder(base) { tableView, indexPath in
            tableView.scrollToRow(at: indexPath,
                                  at: scrollPosition,
                                  animated: animated)
            tableView.layoutIfNeeded()
        }
    }
}
