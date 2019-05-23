//
//  VideoHallHeaderView.swift
//  QYNews
//
//  Created by Insect on 2018/12/20.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallHeaderView: UIView {

    static let height: CGFloat = Configs.Dimensions.screenHeight * 0.4

    @IBOutlet public weak var videoContentView: UIView!

    @IBAction private func backBtnDidClick(_ sender: Any) {
        parentVC?.navigationController?.popViewController(animated: true)
    }
}
