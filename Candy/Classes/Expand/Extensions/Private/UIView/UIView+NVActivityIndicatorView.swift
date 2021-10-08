//
//  UIViewController+LoadingStateable.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

private var context: UInt8 = 0

extension UIView {

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

    func startLoading() {

        let indicatorView = getIndicatorView()
        indicatorView.center = center
        indicatorView.startAnimating()
        addSubview(indicatorView)
    }

    func stopLoading() {

        let indicatorView = getIndicatorView()
        indicatorView.stopAnimating()
        indicatorView.removeFromSuperview()
        activityIndicatorView = nil
    }

    private func getIndicatorView() -> NVActivityIndicatorView {

        var indicatorView: NVActivityIndicatorView
        if let activityIndicatorView = activityIndicatorView {
            indicatorView = activityIndicatorView
        } else {
            indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: 60,
                                                                  height: 60),
                                                    type: .ballRotateChase,
                                                    color: .main,
                                                    padding: 0)
            activityIndicatorView = indicatorView
        }
        return indicatorView
    }
}
