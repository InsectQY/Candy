//
//  EpisodeCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/21.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class EpisodeCell: CollectionViewCell {

    @IBOutlet private weak var titleBtn: Button!

    public var isSel: Bool = false {
        didSet {
            titleBtn.isSelected = isSel
        }
    }

    public var item: String? {
        didSet {
            titleBtn.setTitle(item, for: .normal)
        }
    }
}
