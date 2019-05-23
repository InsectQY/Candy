//
//  NVActivityIndicatorView+Rx.swift
//  Candy
//
//  Created by Insect on 2019/5/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension Reactive where Base: NVActivityIndicatorView {

    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}

extension Reactive where Base: UIViewController {

    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { vc, active in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        }
    }
}

extension UIViewController: NVActivityIndicatorViewable {}
