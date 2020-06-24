//
//  UITableView+Reusable.swift
//  Copyright © 2018年 Insect. All rights reserved.
//

import UIKit

extension UITableView {

    final func dequeueReusableCell<T: UITableViewCell>(withIdentifier identifier: String,
                                                       for indexPath: IndexPath,
                                                       cellType: T.Type = T.self) -> T {
            guard
                let cell = dequeueReusableCell(withIdentifier: identifier,
                                               for: indexPath) as? T
            else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(identifier) matching type \(cellType.self) "
                )
            }
            return cell
    }

    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>
        (withIdentifier identifier: String,
         _ viewType: T.Type = T.self) -> T {

            guard
                let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T
            else {
                fatalError(
                    "Failed to dequeue a header/footer with identifier \(identifier) "
                        + "matching type \(viewType.self)"
                )
            }
            return view
    }
}
