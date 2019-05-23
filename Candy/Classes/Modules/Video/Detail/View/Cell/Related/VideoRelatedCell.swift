//
//  VideoRelatedCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoRelatedCell: TableViewCell {

    @IBOutlet private weak var durationLabel: Label!
    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var subTitleLabel: Label!
    @IBOutlet private weak var thumbImage: ImageView!

    public var item: NewsModel? {
        didSet {

            guard let item = item else { return }
            titleLabel.text = item.title
            subTitleLabel.text = "\(item.source)  \(item.video_detail_info.videoWatchCountString)次播放"
            thumbImage
            .qy_setImage(item.video_detail_info.detail_video_large_image.url)
            durationLabel.text = item.videoDurationString
        }
    }
}
