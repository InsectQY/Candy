//
//  UIViewController+LoadingStateable.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {}

public extension UIViewController {

    func startLoading(isLoading: Bool) {

        var indicatorView: NVActivityIndicatorView
        if let activityIndicatorView = self.activityIndicatorView {
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

        indicatorView.center = view.center

        if isLoading {
            indicatorView.startAnimating()
            view.addSubview(indicatorView)
        } else {
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
            activityIndicatorView = nil
        }
    }
}
