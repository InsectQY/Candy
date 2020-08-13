//
//  VideoHallDetailModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/20.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

struct VideoHallDetailModel: Codable {

    /// 视频信息
    let Album: Album
    /// 播放信息
    let Episode: Episode
    /// 集数信息(数组0是简介 1是集数信息)
    let BlockList: [BlockList]

    /// 所有的剧集
    var episodesInfo: [CellList] {
        BlockList.count > 1 ? BlockList[1].cells : []
    }
}

struct Episode: Codable {

    /// 当前集数
    let seq: Int
    /// 简介
    let intro: String
    /// 标题
    let title: String
    /// 视频播放信息
    let video_info: VideoHallInfo
    /// 每集的播放ID
    let episode_id: String
    /// ID
    let album_id: String
}

struct BlockList: Codable {

    let title: String

    let cells: [CellList]
}

struct CellList: Codable {

    /// 单集信息
    let episode: Episode
    /// 是否选中
    var isSel: Bool
}

struct VideoHallInfo: Codable {

    /// ID
    let vid: String
    /// token(请求视频播放地址的 ptoken)
    let business_token: String
    /// token(请求视频播放地址请求头的 Authorization)
    let auth_token: String
}

struct Role: Codable {

    /// 名字
    let name: String
    /// 扮演角色名称
    let role_name: String
    /// 图片
    let profile_photo_list: [LargeImage]
}
