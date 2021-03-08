//
//  ViewModelObject.swift
//  Candy
//
//  Created by Insect on 2021/2/19.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

private var objectContext: UInt8 = 0

protocol LoadingStateable: class {

    var isLoading: Bool { get set }

    func loadingStateChanged()
}

extension LoadingStateable {

    var isLoading: Bool {
        get {

            if let loading = objc_getAssociatedObject(self, &objectContext) as? Bool {
                return loading
            }

            objc_setAssociatedObject(self,
                                     &objectContext,
                                     false,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return false
        }

        set {
            objc_setAssociatedObject(self,
                                     &objectContext,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            loadingStateChanged()
        }
    }
}
