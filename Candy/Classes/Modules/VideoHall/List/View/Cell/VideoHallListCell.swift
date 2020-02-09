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
                let firstImage = item.album.cover_list.first
            else {
                return
            }
            titleLabel.text = item.album.title
            let options = [KfWebPOptions.webp(),
                           KfWebPOptions.webpCache(),
                           KfOptions.fadeTransition(Configs.Time.imageTransition)]
            // 优先显示长图做封面
            if firstImage.height > firstImage.width {
                largeImage.qy_setImage(firstImage.url,
                                       options: options)
            } else {
                largeImage.qy_setImage(item.album.cover_list[1].url,
                                       options: options)
            }

            if !item.album.bottom_label.isEmpty { // 优先显示多少集
                scoreLabel.text = item.album.bottom_label
            } else if item.album.rating_score > 0 { // 没有总集数时显示评分
                scoreLabel.text = "\(item.album.rating_score / 10)"
            } else { // 都没有时不显示
                scoreLabel.text = ""
            }
        }
    }
}
