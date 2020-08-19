//
//  ShortVideoComment.swift
//  Candy
//
//  Created by Insect on 2020/8/18.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

public struct ShortVideoComment: Codable {
    /// 评论 key
    let rootCmts: [String]
    /// 是否有下一页
    let hasMore: Bool
    /// 分页标识
    let nextCursor: String
    /// 评论内容
    var comments: [ShortVideoCommentItem]
}

public struct ShortVideoCommentItem: Codable {
    /// 评论 ID
    let cmtId: Int
    /// 昵称
    let nickName: String
    /// 头像
    let headUrls: [ShortVideoUrl]
    /// 评论内容
    let content: String
    /// 评论时间
    let realCreateTime: Int
    /// 点赞数量
    let likeCnt: Int
    /// 回复数量
    let replyCnt: Int
    /// 回复的评论 ID
    let replies: [String]

    var contentAttr: NSMutableAttributedString {
        emojiManager.convertEmoji(content: content, font: .pingFangSCRegular(16))
    }

    var likeCountString: String {
        likeCnt.countString
    }

    /// 序列化好的时间
    var createTimeString: String {
        realCreateTime.timeFormat
    }
}
