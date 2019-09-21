//
//  UICollectionView+Rx.swift
//  Candy
//
//  Created by QY on 2019/5/19.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension Reactive where Base: UICollectionView {

    var reloadEmptyDataSet: Binder<Void> {

        Binder(base) { collectionView, _ in
            collectionView.reloadEmptyDataSet()
        }
    }

    var reloadData: Binder<Void> {

        Binder(base) { collectionView, _ in
            collectionView.reloadData()
        }
    }

    func scrollToItem(at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) -> Binder<IndexPath> {

        Binder(base) { collectionView, indexPath in

            collectionView.scrollToItem(at: indexPath,
                                        at: scrollPosition,
                                        animated: animated)
        }
    }
}
