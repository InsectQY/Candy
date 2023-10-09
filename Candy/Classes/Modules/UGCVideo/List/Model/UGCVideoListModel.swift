//
//  UGCVideoListModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/7.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

struct UGCVideoListModel: Codable {
    /// 单条视频内容(返回数据为 JSON 字符串)
    let content: UGCVideoModel
}

struct UGCVideoModel: Codable {
    let raw_data: RawData
}

struct RawData: Codable {
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
    /// 大图
    let large_image_list: [UrlList]
}

struct User: Codable {
    let info: MediaInfo
}

struct Action: Codable {
    /// 评论数量
    let comment_count: Int
    /// 播放量
    let play_count: Int
    /// 点赞数量
    let digg_count: Int

    var playCountString: String {
        play_count.countString
    }

    var diggCountString: String {
        digg_count.countString
    }

    var commentCountString: String {
        comment_count.countString
    }
}

struct UGCVideo: Codable {
    /// 视频播放地址
    let play_addr: UrlList
    /// 视频图片
    let origin_cover: UrlList
}

struct UrlList: Codable {
    /// 图片 URL
    let url_list: [String]
    /// 图片宽度
    let width: CGFloat
    /// 图片高度
    let height: CGFloat

    var firstURL: URL? {
        URL(string: url_list.first ?? "")
    }
}

struct UGCListModel: Codable {
    var caption: String
    var channelCodes: [String]
    var dnwable: Bool
    var download_times: Int
    var favorites: Int
    var height: Int
    var hotspot3: Float
    var iapProductId: String
    var is_video: Bool
    var isFavorited: Bool
    var isKoreaStar: Bool
    var isLiked: Bool
    var isLimitable: Bool
    var isPointable: Bool
    var likes: Int = 0
    var location: String
    var price: Int = 0
    var profile_code: String
    var profileInstance: UGCUserProfile
    var public_slots: [UrlSlots]
    var resDeepTypeName: String
    var resTypeCode: String
    var resTypeName: String
    var shortcode: String
    var slots: [UrlSlots]
    var temp_hotspot: Float
    var temp_hotspot_3: Float
    var thumbnail: String
    var type: String
    var upload_ts: String
    var video_duration: Float
    var width: Int

    var videoUrl: String {
        "\(Configs.Network.macooResUrl)/e/\(shortcode)/\(slots.first?.video ?? "")"
    }

    var imageUrl: String {
        "\(Configs.Network.macooResUrl)/e/\(shortcode)/\(slots.first?.pic ?? "")"
    }
}

struct UrlSlots: Codable {
    var pic: String
    var video: String
}

struct UGCUserProfile: Codable {
    var avatar: String
    var channel_codes: [String]
    var code: String
    var description: String
    var name: String

    var avatarUrl: String {
        "\(Configs.Network.macooResUrl)\(avatar)"
    }
}
