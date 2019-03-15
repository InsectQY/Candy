//
//  UICollectionView+Reusable.swift
//  Copyright © 2018年 Insect. All rights reserved.
//

import UIKit

extension UICollectionView {

    /// register nib
    ///
    /// - Parameter cellType: UICollectionViewCell subclass
    final func register<T: UICollectionViewCell>(cellType: T.Type)
        where T: Reusable & NibLoadable {
            register(cellType.Nib, forCellWithReuseIdentifier: cellType.ID)
    }

    final func register<T: UICollectionViewCell>(cellType: T.Type)
        where T: Reusable {
            register(cellType.self, forCellWithReuseIdentifier: cellType.ID)
    }

    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T

        where T: Reusable {

            let bareCell = dequeueReusableCell(withReuseIdentifier: cellType.ID, for: indexPath)
            guard let cell = bareCell as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.ID) matching type \(cellType.self)"
                )
            }
            return cell
    }

    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String)

        where T: Reusable & NibLoadable {

            register(
                supplementaryViewType.Nib,
                forSupplementaryViewOfKind: elementKind,
                withReuseIdentifier: supplementaryViewType.ID
            )
    }

    final func register<T: UICollectionReusableView>(supplementaryViewType: T.Type, ofKind elementKind: String)

        where T: Reusable {

            register(
                supplementaryViewType.self,
                forSupplementaryViewOfKind: elementKind,
                withReuseIdentifier: supplementaryViewType.ID
            )
    }

    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
        (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T
        where T: Reusable {

            let view = dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: viewType.ID,
                for: indexPath
            )
            guard let typedView = view as? T else {
                fatalError(
                    "Failed to dequeue a supplementary view with identifier \(viewType.ID) "
                )
            }
            return typedView
    }
}
