//
//  VideoModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/5.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import CleanJSON

class NewsListModel: Codable {

    /// 单条新闻内容(返回数据为 JSON 字符串)
    let content: NewsModel
}

class NewsModel: Codable {

    /// 广告
    let label: String
    let show_tag: String
    /// ID
    let group_id: String
    let item_id: String
    /// 标题
    let title: String
    /// 简介
    let abstract: String
    /// 新闻来源
    let source: String
    /// 发布人信息
    let user_info: MediaInfo
    /// 评论数
    let comment_count: Int
    /// 点赞数
    let digg_count: Int
    /// 当该字段大于0时，代表是图集新闻
    let gallary_image_count: Int
    /// 转发内容
    let forward_info: ForwardInfo
    /// 视频时长(单位/s)
    let video_duration: Int
    /// 发布时间
    let publish_time: Int
    /// 视频详情
    let video_detail_info: VideoDetailInfo
    /// 视频播放信息(返回数据为 JSON 字符串)
    let video_play_info: VideoPlayInfo
    /// 视频 ID
    let video_id: String
    /// 图片列表
    let large_image_list: [LargeImage]

    /// 视频时长
    lazy var videoDurationString = video_duration.timeDuration

    /// 发布时间
    lazy var publishTimeString: String = {

        let timeDate = Date(timeIntervalSince1970: TimeInterval(publish_time))
        return timeDate.string(withFormat: "yyyy年MM月dd日")
    }()

    /// 点赞数
    lazy var diggCountString = digg_count.countString

    /// 评论数
    lazy var commentCountString = comment_count.countString
}

class ForwardInfo: Codable {

    /// 转发数
    let forward_count: Int
    /// 转发数
    lazy var forwardCountString = forward_count.countString
}

class VideoDetailInfo: Codable {

    /// 视频ID
    let video_id: String
    /// 视频播放次数
    let video_watch_count: Int
    /// 视频大图
    let detail_video_large_image: LargeImage

    lazy var videoWatchCountString = video_watch_count.countString
}

class LargeImage: Codable {

    /// 图片URL
    let url: String
    /// 高
    let height: CGFloat
    /// 宽
    let width: CGFloat
}

class MediaInfo: Codable {

    /// 头像
    let avatar_url: String
    /// 名字
    let name: String
    /// 是否认证
    let user_verified: Bool
    /// ID
    let user_id: String
    /// 认证信息
    let verified_content: String
}

class VideoPlayInfo: Codable {

    let video_list: VideoList
}

class VideoList: Codable {

    let video_1: Video
    let video_2: Video
    let video_3: Video
    let video_4: Video
}

class Video: Codable {

    /// 清晰度
    let definition: String
    /// 用 base 64 加密的视频真实地址
    let main_url: String

    /// 解析好的真实播放地址
    lazy var mainURL: String = {
        guard let decodeData = Data(base64Encoded: main_url, options: Data.Base64DecodingOptions(rawValue: 0)) else { return "" }
        return String(data: decodeData, encoding: .utf8) ?? ""
    }()
}
