//
//  TopView.swift
//  QYNews
//
//  Created by Insect on 2019/2/25.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class TopView: Button {

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        setTitle(R.string.localizable.videoHallTopViewTitle(), for: .normal)
        setTitleColor(.main, for: .normal)
        backgroundColor = .white
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
