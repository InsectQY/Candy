//
//  UGCVideoListCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class UGCVideoListCell: CollectionViewCell {

    @IBOutlet private weak var diggCountLabel: Label!
    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private(set) weak var coverImage: ImageView!

    public var item: UGCListModel? {
        didSet {

            guard let item else { return }
            coverImage.qy_setImage(item.imageUrl,
                                   options: [KfOptions.fadeTransition(Configs.Time.imageTransition)])
            titleLabel.text = item.caption
            diggCountLabel.text = "\(item.likes)赞"
            hero.id = item.shortcode
        }
    }
}
