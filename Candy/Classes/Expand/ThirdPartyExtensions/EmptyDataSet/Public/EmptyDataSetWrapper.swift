//
//  EmptyDataSetWrapper.swift
//  Candy
//
//  Created by Insect on 2021/9/28.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit

public struct EmptyDataSetWrapper<Base> {

    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}
