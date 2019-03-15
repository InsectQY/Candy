//
//  UserVideoCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserVideoCell: TableViewCell, NibReusable {

    // MARK: - IBOutlet
    @IBOutlet private weak var videoDurationLabel: Label!
    @IBOutlet private weak var videoImage: ImageView!
    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var subTitleLabel: Label!
    @IBOutlet private weak var nameLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private weak var shareBtn: Button!
    @IBOutlet private weak var commentBtn: Button!
    @IBOutlet private weak var diggBtn: Button!

    // MARK: - public
    public var item: NewsListModel? {

        didSet {

            guard let item = item?.news else { return }
            titleLabel.text = item.title

            let imageSize = CGSize(width: 40 * UIScreen.main.scale, height: 40 * UIScreen.main.scale)
            avatarImage.qy_setImage(item.user_info.avatar_url, options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            nameLabel.text = item.user_info.name
            videoDurationLabel.text = item.videoDurationString
            videoImage
            .qy_setImage(item.video_detail_info.detail_video_large_image.url)
            let sub = item.user_info.verified_content.isEmpty ? item.publish_time.timeFormat :  item.publish_time.timeFormat + "·" + item.user_info.verified_content
            subTitleLabel.text = sub
            commentBtn.setTitle(" \(item.commentCountString)", for: .normal)
            diggBtn.setTitle(" \(item.diggCountString)", for: .normal)
            shareBtn.setTitle(" \(item.forward_info.forwardCountString)", for: .normal)
        }
    }
}
