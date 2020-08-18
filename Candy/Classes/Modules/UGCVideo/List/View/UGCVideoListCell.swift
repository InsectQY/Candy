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

    public var item: ShortVideoItem? {
        didSet {

            guard let item = item else { return }
            coverImage.qy_setImage(item.videoInfo.coverImg.urls.first?.url ?? "",
                                   options: [KfOptions.fadeTransition(Configs.Time.imageTransition)])
            titleLabel.text = item.caption
            playCountLabel.text = "\(item.viewCountString)次播放"
            diggCountLabel.text = "\(item.likeCountString)赞"
            hero.id = item.itemId
        }
    }
}
