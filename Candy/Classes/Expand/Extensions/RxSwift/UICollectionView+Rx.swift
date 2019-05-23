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

        return Binder(base) { collectionView, _ in
            collectionView.reloadEmptyDataSet()
        }
    }
}
