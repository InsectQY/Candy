//
//  CommentCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import Jelly
import Kingfisher

class CommentCell: TableViewCell {

    @IBOutlet private weak var replyBtn: Button!
    @IBOutlet private weak var timeLabel: Label!
    @IBOutlet private weak var commentLabel: RichLabel!
    @IBOutlet private weak var userNameLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private weak var diggCountBtn: Button!

    /// 是否是小视频的详情
    public var isUGCVideo: Bool = false

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
            diggCountBtn.setTitle(" \(item.likeCountString)", for: .normal)

            if item.replyCnt == 0 {

                replyBtn.isHidden = true
                timeLabel.text = item.createTimeString
            } else {

                replyBtn.isHidden = false
                replyBtn.setTitle("\(item.replyCnt)回复", for: .normal)
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
            avatarImage.qy_setImage(item.user.avatar_url)
            timeLabel.text = item.createTimeString
            diggCountBtn.setTitle(" \(item.diggCountString)", for: .normal)
            commentLabel.attributedText = item.replyToText
        }
    }

    // 查看回复评论
    @IBAction private func replyBtnDidClick(_ sender: Any) {

//        let vc = ReplyCommentViewController(comment: item)
//
//        var animator: Animator?
//        if isUGCVideo {
//            animator = JellyManager.UGCReplyComment(presentingVc: parentVC)
//        } else {
//            animator = JellyManager.videoReplyComment()
//        }
//        animator?.prepare(presentedViewController: vc)
//        parentVC?.present(vc, animated: true, completion: nil)
    }
}
