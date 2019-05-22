//
//  UserUGCVideoCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserUGCVideoCell: CollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var diggCountLabel: Label!
    @IBOutlet private weak var largeImage: ImageView!

    // MARK: - public
    public var item: UGCVideoListModel? {
        didSet {

            guard let item = item?.content.raw_data else { return }

            largeImage.qy_setImage(item.video.origin_cover.url_list.first)
            diggCountLabel.text = "\(item.action.diggCountString)赞"
        }
    }
}
