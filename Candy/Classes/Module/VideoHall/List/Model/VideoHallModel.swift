//
//  VideoHallModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

struct VideoHallModel: Codable {

    /// 是否有更多数据
    let has_more: Bool

    let cell_list: [VideoHallList]
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
}

struct CoverList: Codable {

    /// 图片url
    let url: String
    /// 图片高度
    let height: Int
    /// 图片宽度
    let width: Int
}
