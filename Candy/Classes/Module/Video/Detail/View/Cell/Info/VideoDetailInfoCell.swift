//
//  VideoDetailInfoCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoDetailInfoCell: TableViewCell, NibReusable {

    @IBOutlet private weak var abstractLabel: Label!
    @IBOutlet private weak var publishTimeLabel: Label!
    @IBOutlet private weak var playCountLabel: Label!
    @IBOutlet private weak var titleLabel: Label!

    public var item: NewsModel? {

        didSet {

            guard let item = item else { return }
            abstractLabel.text = item.abstract
            playCountLabel.text = "\(item.video_detail_info.videoWatchCountString)次播放"
            titleLabel.text = item.title
            publishTimeLabel.text = "\(item.publishTimeString)发布"
        }
    }
}
