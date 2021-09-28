//
//  EmptyDataSetWrapper.swift
//  Candy
//
//  Created by Insect on 2021/9/28.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit

public class EmptyDataSetWrapper {

    let base: UIScrollView

    init(_ base: UIScrollView) {
        self.base = base
    }
}

public extension UIScrollView {

    var emptyDataSet: EmptyDataSetWrapper {
        EmptyDataSetWrapper(self)
    }
}
