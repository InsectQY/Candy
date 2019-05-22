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
            let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
        else {
            fatalError(
                "Failed to dequeue a cell with identifier \(identifier) matching type \(cellType.self) "
            )
        }
        return cell
    }

//    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
//        (ofKind elementKind: String,
//         for indexPath: IndexPath,
//         viewType: T.Type = T.self) -> T
//        where T: Reusable {
//
//            let view = dequeueReusableSupplementaryView(
//                ofKind: elementKind,
//                withReuseIdentifier: viewType.ID,
//                for: indexPath
//            )
//            guard let typedView = view as? T else {
//                fatalError(
//                    "Failed to dequeue a supplementary view with identifier \(viewType.ID) "
//                )
//            }
//            return typedView
//    }
}
