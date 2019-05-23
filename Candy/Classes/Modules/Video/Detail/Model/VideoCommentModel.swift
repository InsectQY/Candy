//
//  VideoDetailModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/10.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

class VideoCommentModel: Codable {

    /// 评论ID
    let id: String
    /// 评论内容
    let comment: Comment
}

class Comment: Codable {

    /// 评论ID
    let id: String
    /// 评论内容
    let text: String
    /// 回复数量
    let reply_count: Int
    /// 评论时间
    let create_time: Int
    /// 用户 ID
    let user_id: String
    /// 用户名
    let user_name: String
    /// 用户头像
    let user_profile_image_url: String
    /// 点赞数
    let digg_count: Int
    /// 评论图片
    let large_image_list: [LargeImage]

    /// 点赞数量
    lazy var diggCountString = digg_count.countString

    /// 带有表情的富文本
    lazy var attrText = emojiManager.convertEmoji(content: text, font: .pingFangSCRegular(16))

    /// 序列化好的时间
    lazy var createTimeString = create_time.timeFormat
}
