//
//  UGCVideoListModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import CleanJSON

class UGCVideoListModel: Codable {

    /// 单条视频内容(返回数据为 JSON 字符串)
    let content: String
    /// 解析好的 Model
    lazy var video: UGCVideoModel? = {

        guard let data = content.data(using: .utf8), let model = try? CleanJSONDecoder().decode(UGCVideoModel.self, from: data) else { return nil }
        return model
    }()
}

class UGCVideoModel: Codable {

    let raw_data: RawData
}

class RawData: Codable {

    /// ID
    let group_id: String
    let item_id: String
    /// 视频信息
    let video: UGCVideo
    /// 播放数量信息
    let action: Action
    /// 视频标题
    let title: String
    /// 发布用户
    let user: User
}

class User: Codable {

    let info: MediaInfo
}

class Action: Codable {

    /// 评论数量
    let comment_count: Int
    /// 播放量
    let play_count: Int
    /// 点赞数量
    let digg_count: Int

    lazy var playCountString = play_count.countString

    lazy var diggCountString = digg_count.countString

    lazy var commentCountString = comment_count.countString
}

class UGCVideo: Codable {

    /// 视频播放地址
    let play_addr: URLList
    /// 视频图片
    let origin_cover: URLList
}

class URLList: Codable {
    let url_list: [String]
}
