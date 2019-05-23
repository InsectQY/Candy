//
//  VideoHallSearchResult.swift
//  QYNews
//
//  Created by Insect on 2019/1/9.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

struct VideoHallSearchResult: Codable {

    let data: [VideoHallSearchResultList]
    /// 是否有更多数据
    let has_more: Bool
}

struct VideoHallSearchResultList: Codable {

    let display: Display
}

struct Display: Codable {

    /// 评分
    let rating: String
    /// 地区
    let area_tags: [String]
    /// 演员
    let actor: String
    /// 年代
    let year: String
    /// 地区
    let area: String
    /// 视频名称
    let name: String
    /// 导演
    let director: String
    /// 简介
    let summary: String
    /// 视频信息
    let album_content: [AlbumContent]
    /// 视频图片
    let video_cover_info: LargeImage
}

struct AlbumContent: Codable {

    let album_id: String
}
