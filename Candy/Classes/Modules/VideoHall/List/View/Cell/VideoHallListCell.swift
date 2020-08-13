//
//  VideoHallListCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import KingfisherWebP

class VideoHallListCell: CollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var largeImage: ImageView!
    @IBOutlet private weak var scoreLabel: Label!
    @IBOutlet private weak var titleLabel: Label!

    public var item: VideoHallList? {
        didSet {

            guard
                let item = item,
                let coverImage = item.album.coverImage
            else {
                return
            }
            titleLabel.text = item.album.title
            let options = [KfWebPOptions.webp(),
                           KfWebPOptions.webpCache(),
                           KfOptions.fadeTransition(Configs.Time.imageTransition)]
            // 优先显示长图做封面
            largeImage.qy_setImage(coverImage,
                                   options: options)

            scoreLabel.text = item.album.bottomTitle
        }
    }
}
