//
//  UINavigationBarWrapper.swift
//  Scanking
//
//  Created by Scanking on 2021/09/15.
//  Copyright © 2021 Scanking. All rights reserved.
//

import Foundation

public class UINavigationBarWrapper<Base> {
    
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}
