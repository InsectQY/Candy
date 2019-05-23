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
    @IBOutlet private weak var playCountLabel: Label!
    @IBOutlet private(set) weak var coverImage: ImageView!

    public var item: UGCVideoListModel? {

        didSet {

            guard let item = item else { return }

            let url = item.content.raw_data.video.origin_cover.url_list.first
            coverImage.qy_setImage(url, options: [KfOptions.fadeTransition(Configs.Time.imageTransition)])
            titleLabel.text = item.content.raw_data.title
            playCountLabel.text = "\(item.content.raw_data.action.playCountString)次播放"
            diggCountLabel.text = "\(item.content.raw_data.action.diggCountString)赞"
        }
    }
}
