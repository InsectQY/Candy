//
//  UITableView+Reusable.swift
//  Copyright © 2018年 Insect. All rights reserved.
//

import UIKit

extension UITableView {

    final func register<T: UITableViewCell>(cellType: T.Type)
        where T: Reusable & NibLoadable {
            register(cellType.Nib, forCellReuseIdentifier: cellType.ID)
    }

    final func register<T: UITableViewCell>(cellType: T.Type)
        where T: Reusable {
            register(cellType.self, forCellReuseIdentifier: cellType.ID)
    }

    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T

        where T: Reusable {

            guard let cell = dequeueReusableCell(withIdentifier: cellType.ID, for: indexPath) as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.ID) matching type \(cellType.self) "
                )
            }
            return cell
    }

    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)

        where T: Reusable & NibLoadable {

            register(headerFooterViewType.Nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.ID)
    }

    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)

        where T: Reusable {

            register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.ID)
    }

    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T

        where T: Reusable {

            guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.ID) as? T else {
                fatalError(
                    "Failed to dequeue a header/footer with identifier \(viewType.ID) "
                        + "matching type \(viewType.self)"
                )
            }
            return view
    }
}
