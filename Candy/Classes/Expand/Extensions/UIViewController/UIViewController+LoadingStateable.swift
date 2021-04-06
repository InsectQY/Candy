//
//  UIViewController+LoadingStateable.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

extension ViewController: LoadingStateable {

    @objc func loadingStateChanged() {
        if isLoading {
            HUD.startLoading()
        } else {
            HUD.stopLoading()
        }
    }
}
