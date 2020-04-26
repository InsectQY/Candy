//
//  HUD.swift
//  NewRetailPlatform
//
//  Created by QY on 2020/4/26.
//  Copyright © 2020 RocketsChen. All rights reserved.
//

import NVActivityIndicatorView

public class HUD {
    static func startLoading() {
        NVActivityIndicatorPresenter
        .sharedInstance
        .startAnimating(ActivityData())
    }

    static func stopLoading() {
        NVActivityIndicatorPresenter
        .sharedInstance
        .stopAnimating()
    }
}
