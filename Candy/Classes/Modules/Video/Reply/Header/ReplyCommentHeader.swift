//
//  ReplyCommentHeader.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import Kingfisher

class ReplyCommentHeader: UIView {

    @IBOutlet private weak var timeLabel: Label!
    @IBOutlet private weak var commentLabel: Label!
    @IBOutlet private weak var userNameLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!

    /// 单条评论详情
    public var item: ShortVideoCommentItem? {
        didSet {

            guard let item = item else { return }
            userNameLabel.text = item.nickName
            var options: [KingfisherOptionsInfoItem] = []
            if item.headUrls.first?.isWebP ?? false {
                options += [KfWebPOptions.webp(),
                            KfWebPOptions.webpCache()]
            }
            avatarImage.qy_setImage(item.headUrls.first?.url,
                                    placeholder: R.image.avatar(),
                                    options: options)
            commentLabel.attributedText = item.contentAttr
            timeLabel.text = item.createTimeString
        }
    }

}
