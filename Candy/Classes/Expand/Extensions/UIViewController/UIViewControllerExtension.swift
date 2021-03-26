//
//  UIViewControllerExtension.swift
//  Candy
//
//  Created by Insect on 2019/5/20.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

extension UIViewController {

    func setNavBarTransparent(_ isNavgationBarTransparent: Bool) {
        if isNavgationBarTransparent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                   for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            navigationController?.navigationBar.setBackgroundImage(nil,
                                                                   for: .default)
            navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    public func disablesAdjustScrollViewInsets(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
