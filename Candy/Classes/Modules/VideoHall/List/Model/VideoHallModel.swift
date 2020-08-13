//
//  VideoHallModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

struct VideoHallModel: Codable {

    let IndexResponse: IndexResponse
    let CellList: [VideoHallList]
}

struct IndexResponse: Codable {
    /// 是否有更多数据
    let has_more: Bool
}

struct VideoHallList: Codable {

    /// 视频信息
    let album: Album
}

struct Album: Codable {

    /// ID
    let album_id: String
    /// 视频名称
    let title: String
    /// 视频小标题
    let sub_title: String
    /// 底部名称
    let bottom_label: String
    /// 图片
    let cover_list: [CoverList]
    /// 最近更新的集
    let latest_seq: Int
    /// 介绍
    let intro: String
    /// 年代
    let year: String
    /// 总集数
    let total_episodes: Int
    /// 点赞数量
    let digg_count: Int
    /// 上映地区
    let area_list: [String]
    /// 视频标签
    let tag_list: [String]
    /// 演员表
    let actor_list: [Role]
    /// 导演表
    let director_list: [Role]
    /// 评分
    let rating_score: Float

    /// 是否是多集视频
    var isMultipleEpisode: Bool {
        total_episodes > 1
    }

    /// 优先显示长图做封面
    var coverImage: String? {
        guard
            let firstImage = cover_list.first
        else {
            return nil
        }

        if firstImage.height > firstImage.width {
            return firstImage.url
        } else {
            if cover_list.count > 1 {
                return cover_list[1].url
            }
        }
        return nil
    }

    /// 列表封面底部展示的文字
    var bottomTitle: String {

        if !bottom_label.isEmpty { // 优先显示多少集
            return bottom_label
        } else if rating_score > 0 { // 没有总集数时显示评分
            return "\(rating_score / 10)"
        } else { // 都没有时不显示
            return ""
        }
    }
}

struct CoverList: Codable {

    /// 图片url
    let url: String
    /// 图片高度
    let height: Int
    /// 图片宽度
    let width: Int
}
