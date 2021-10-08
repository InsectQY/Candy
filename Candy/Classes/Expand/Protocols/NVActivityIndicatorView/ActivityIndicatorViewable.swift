//
//  ActivityIndicatorViewable.swift
//  Candy
//
//  Created by QY on 2021/10/2.
//  Copyright © 2021 Insect. All rights reserved.
//

import NVActivityIndicatorView

private var context: UInt8 = 0

protocol NVActivityIndicatorViewable {

    var activityIndicatorView: NVActivityIndicatorView? { get set }
}

extension NVActivityIndicatorViewable {

    var activityIndicatorView: NVActivityIndicatorView? {
            get {
                objc_getAssociatedObject(self, &context) as? NVActivityIndicatorView
            }

            set {
                objc_setAssociatedObject(self,
                                         &context,
                                         newValue,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
    }
}
