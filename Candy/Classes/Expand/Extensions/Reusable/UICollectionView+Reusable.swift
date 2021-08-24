//
//  UICollectionView+Reusable.swift
//  Copyright © 2018年 Insect. All rights reserved.
//

import UIKit

extension UICollectionView {

    final func dequeueReusableCell<T: UICollectionViewCell>
        (withIdentifier identifier: String,
         for indexPath: IndexPath,
         cellType: T.Type = T.self) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: identifier,
                                           for: indexPath) as? T
        else {
            fatalError(
                "Failed to dequeue a cell with identifier \(identifier) matching type \(cellType.self) "
            )
        }
        return cell
    }

    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
        (withIdentifier identifier: String,
         ofKind elementKind: String,
         for indexPath: IndexPath,
         viewType: T.Type = T.self) -> T {

            let view = dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: identifier,
                for: indexPath
            )
            guard
                let typedView = view as? T
            else {
                fatalError(
                    "Failed to dequeue a supplementary view with identifier \(identifier) "
                )
            }
            return typedView
    }
}
