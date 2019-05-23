//
//  ReplyCommentModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/29.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

class ReplyCommentModel: Codable {

    /// 是否有更多
    let has_more: Bool
    /// 评论内容
    let data: [ReplyComment]
}

class ReplyComment: Codable {

    /// 评论内容
    let text: String
    /// 用户名
    let user: ReplyUser
    /// 回复评论内容
    let reply_to_comment: Comment?
    /// 创建时间
    let create_time: Int
    /// 点赞数量
    let digg_count: Int

    /// 带有表情的富文本
    lazy var attrText = emojiManager.convertEmoji(content: text, font: .pingFangSCRegular(16))

    /// 回复某条评论的富文本
    lazy var replyToText: NSMutableAttributedString = {

        if let replyTo = reply_to_comment {

            let comment = NSMutableAttributedString()
            let userName = "//@\(replyTo.user_name): "
            comment.append(attrText)
            comment.append(NSAttributedString(string: userName))
            comment.append(replyTo.attrText)
            return comment
        } else {
            return attrText
        }
    }()

    /// 序列化好的时间
    lazy var createTimeString = create_time.timeFormat

    lazy var diggCountString = digg_count.countString
}

class ReplyUser: Codable {

    /// 用户名
    let name: String
    /// 头像
    let avatar_url: String
}
