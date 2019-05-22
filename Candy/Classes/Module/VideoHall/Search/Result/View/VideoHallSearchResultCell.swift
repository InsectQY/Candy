//
//  VideoHallSearchResultCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/9.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class VideoHallSearchResultCell: TableViewCell {

    public static let height: CGFloat = 190

    @IBOutlet private weak var abstractLabel: Label!
    @IBOutlet private weak var yearLabel: Label!
    @IBOutlet private weak var actorLabel: Label!
    @IBOutlet private weak var videoImage: ImageView!
    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var directorLabel: Label!

    public var item: VideoHallSearchResultList? {
        didSet {

            guard let item = item?.display else { return }
            videoImage.qy_setImage(item.video_cover_info.url, options: [KfWebPOptions.webp(), KfWebPOptions.webpCache()])
            yearLabel.text = "年份: \(item.year)"
            actorLabel.text = "主演: \(item.actor)"
            titleLabel.text = item.name
            directorLabel.text = "导演: \(item.director)"
            abstractLabel.attributedText = "简介: \(item.summary)".lineSpace(6)
        }
    }
}
