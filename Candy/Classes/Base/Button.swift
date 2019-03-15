//
//  BaseButton.swift
//  GamerSky
//
//  Created by QY on 2018/4/4.
//  Copyright © 2018年 QY. All rights reserved.
//

import UIKit

class Button: UIButton {

    // MARK: - Inital
    public override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    /// required
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        layer.masksToBounds = true
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

// MARK: - 自适应字体
extension Button {

    private func fitFontSize() {

        guard let font = titleLabel?.font else { return }
        titleLabel?.font = UIFont(name: font.fontName, size: KScaleH(font.pointSize))
    }
}
