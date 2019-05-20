//
//  QAModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import CleanJSON

class QAModel: Codable {

    let content: String

    lazy var wenda: WenDa? = {

        guard
            let data = content.data(using: .utf8),
            let model = try? CleanJSONDecoder().decode(WenDa.self, from: data)
        else {
            return nil
        }
        return model
    }()
}

class WenDa: Codable {

    let raw_data: QARawData
}

class QARawData: Codable {

    let content: QAContent
}

class QAContent: Codable {

    /// 回答
    let answer: QAAnswer
    /// 问题
    let question: QAQuestion
    /// 用户
    let user: QAUser
}

class QAAnswer: Codable {

    /// 回答内容
    let abstract_text: String
    /// 回答 ID
    let ansid: String
    /// 回答图片
    let large_image_list: [LargeImage]
    /// 点赞数
    let digg_count: Int
    /// 评论数
    let comment_count: Int
    /// 转发数
    let forward_count: Int
    /// 评论时间
    let create_time: Int

    /// 序列化好的时间
    lazy var createTimeString = create_time.timeFormat

    /// 点赞数
    lazy var diggCountString = digg_count.countString

    /// 评论数
    lazy var commentCountString = comment_count.countString

    /// 转发数
    lazy var forwardCountString = forward_count.countString
}

class QAQuestion: Codable {

    /// 创建时间
    let create_time: Int
    /// 问题 ID
    let qid: String
    /// 问题标题
    let title: String
}

class QAUser: Codable {

    /// 头像
    let avatar_url: String
    /// 用户名
    let uname: String
    /// 认证内容
    let v_icon: String
}
