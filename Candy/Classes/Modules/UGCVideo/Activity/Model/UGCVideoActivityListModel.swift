//
//  UGCVideoActivityListModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/11.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

struct UGCVideoActivityListModel: Codable {

    /// 是否有更多页
    let has_more: Bool

    let album_list: [UGCVideoActivityAlbumList]
}

struct UGCVideoActivityAlbumList: Codable {

    let album_info: UGCVideoActivityAlbumInfo

    let video_list: [UGCVideoModel]
}

struct UGCVideoActivityAlbumInfo: Codable {

    /// 活动 ID
    let album_id: String
    /// 活动图片
    let album_icon_url: String
    /// 活动名称
    let album_name: String
    /// 活动标签
    let album_label: String
    /// 目前活动有多少视频加入
    let album_participate_info: String
}
