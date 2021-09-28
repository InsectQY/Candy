//
//  UIViewController+LoadingStateable.swift
//  Candy
//
//  Created by Insect on 2021/3/26.
//  Copyright © 2021 Insect. All rights reserved.
//

import UIKit

extension ViewController {

    func startLoading(isLoading: Bool) {
        if isLoading {
            HUD.startLoading()
        } else {
            HUD.stopLoading()
        }
    }
}
