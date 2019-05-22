//
//  CommentCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import Jelly

class CommentCell: TableViewCell {

    @IBOutlet private weak var replyBtn: Button!
    @IBOutlet private weak var timeLabel: Label!
    @IBOutlet private weak var commentLabel: RichLabel!
    @IBOutlet private weak var userNameLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private weak var diggCountBtn: Button!

    /// 是否是小视频的详情
    public var isUGCVideo: Bool = false

    private let imageSize = CGSize(width: 40 * UIScreen.main.scale, height: 40 * UIScreen.main.scale)

    private var animator: JellyAnimator?

    /// 单条评论详情
    public var item: Comment? {
        didSet {

            guard let item = item else { return }
            userNameLabel.text = item.user_name
            avatarImage.qy_setImage(item.user_profile_image_url, placeholder: "avatar", options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            commentLabel.attributedText = item.attrText
            diggCountBtn.setTitle(" \(item.diggCountString)", for: .normal)

            if item.reply_count == 0 {

                replyBtn.isHidden = true
                timeLabel.text = item.createTimeString
            } else {

                replyBtn.isHidden = false
                replyBtn.setTitle("\(item.reply_count)回复", for: .normal)
                timeLabel.text = item.createTimeString + " ·"
            }
        }
    }

    /// 回复某条评论的详情
    public var reply: ReplyComment? {
        didSet {

            replyBtn.isHidden = true

            guard let item = reply else { return }
            userNameLabel.text = item.user.name
            avatarImage.qy_setImage(item.user.avatar_url, options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            timeLabel.text = item.createTimeString
            diggCountBtn.setTitle(" \(item.diggCountString)", for: .normal)
            commentLabel.attributedText = item.replyToText
        }
    }

    // 查看回复评论
    @IBAction private func replyBtnDidClick(_ sender: Any) {

        let vc = ReplyCommentViewController(comment: item)
        var presentation = JellySlideInPresentation()
        if isUGCVideo {

            presentation.heightForViewController = .custom(value: ScreenHeight * 0.7)
            presentation.directionShow = .right
            presentation.directionDismiss = .right
            presentation.cornerRadius = 5
        } else {

            presentation.heightForViewController = .custom(value: ScreenHeight - VideoDetailHeader.height + VideoDetailHeader.bottomHeight)
            presentation.directionShow = .bottom
            presentation.directionDismiss = .bottom
        }

        presentation.verticalAlignemt = .bottom
        animator = JellyAnimator(presentation: presentation)
        animator?.prepare(viewController: vc)
        parentVC?.present(vc, animated: true, completion: nil)
    }
}
