//
//  ReplyCommentHeader.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class ReplyCommentHeader: UIView, NibLoadable {

    @IBOutlet private weak var timeLabel: Label!
    @IBOutlet private weak var commentLabel: Label!
    @IBOutlet private weak var userNameLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!

    /// 单条评论详情
    public var item: Comment? {
        didSet {

            guard let item = item else { return }
            userNameLabel.text = item.user_name
            let imageSize = CGSize(width: 40 * UIScreen.main.scale, height: 40 * UIScreen.main.scale)
            avatarImage.qy_setImage(item.user_profile_image_url, placeholder: "avatar", options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            commentLabel.attributedText = item.attrText
            timeLabel.text = item.createTimeString

            layoutIfNeeded()
        }
    }
}
