//
//  UserArticleMultiImageCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserArticleMultiImageCell: TableViewCell {

    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var image3: ImageView!
    @IBOutlet private weak var image2: ImageView!
    @IBOutlet private weak var image1: ImageView!
    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private weak var nameLabel: Label!
    @IBOutlet private weak var subTitleLabel: Label!
    @IBOutlet private weak var shareBtn: Button!
    @IBOutlet private weak var commentBtn: Button!
    @IBOutlet private weak var diggBtn: Button!

    public var item: NewsListModel? {
        didSet {

            guard let item = item?.content else { return }
            titleLabel.text = item.title

            let kfOptions = [KfWebPOptions.webp(),
                             KfWebPOptions.webpCache()]
            image1.qy_setImage(item.large_image_list.first?.url, options: kfOptions)
            image2.qy_setImage(item.large_image_list[1].url, options: kfOptions)
            image3.qy_setImage(item.large_image_list[2].url, options: kfOptions)

            let imageSize = CGSize(width: 40 * UIScreen.main.scale, height: 40 * UIScreen.main.scale)
            avatarImage.qy_setImage(item.user_info.avatar_url, options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            nameLabel.text = item.user_info.name

            let sub = item.user_info.verified_content.isEmpty ? item.publish_time.timeFormat :  item.publish_time.timeFormat + "·" + item.user_info.verified_content
            subTitleLabel.text = sub
            commentBtn.setTitle(" \(item.commentCountString)", for: .normal)
            diggBtn.setTitle(" \(item.diggCountString)", for: .normal)
            shareBtn.setTitle(" \(item.forward_info.forwardCountString)", for: .normal)
        }
    }
}
