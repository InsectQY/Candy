//
//  ViewModelObject.swift
//  Candy
//
//  Created by Insect on 2021/2/19.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

private var context: UInt8 = 0

protocol LoadingStateable: AnyObject {
    var isLoading: Bool { get set }

    func loadingStateChanged()
}

extension LoadingStateable {
    var isLoading: Bool {
        get {
            if let object = objc_getAssociatedObject(self, &context) as? Bool {
                return object
            }

            objc_setAssociatedObject(self,
                                     &context,
                                     false,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return false
        }

        set {
            if newValue == isLoading {
                return
            }
            objc_setAssociatedObject(self,
                                     &context,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            loadingStateChanged()
        }
    }

    func loadingStateChanged() {}
}
