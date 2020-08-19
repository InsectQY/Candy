//
//  ShortVideoModel.swift
//  Candy
//
//  Created by Insect on 2020/8/18.
//  Copyright © 2020 Insect. All rights reserved.
//

import Foundation

public struct ShortVideoModel: Codable {
    /// 视频信息
    let items: [ShortVideoItem]
}

public struct ShortVideoItem: Codable {
    /// 视频ID
    let itemId: String
    /// 标题
    let caption: String
    /// 简介
    let summary: String
    /// 观看次数
    let viewCnt: Int
    /// 喜欢次数
    let likeCnt: Int
    /// 评论次数
    let cmtCnt: Int
    /// 视频信息
    let videoInfo: ShortVideoInfo
    /// 作者信息
    let authorInfo: ShortVideoAuthor

    var viewCountString: String {
        viewCnt.countString
    }

    var likeCountString: String {
        likeCnt.countString
    }
}

public struct ShortVideoInfo: Codable {
    /// 视频信息
    let videoUrls: [ShortVideoUrl]
    /// 图片信息
    let coverImg: ShortVideoImage
}

public struct ShortVideoUrl: Codable {
    /// URL 地址
    let url: String
    /// URL 地址
    var playURL: URL? {
        URL(string: url)
    }

    var isWebP: Bool {
        url.hasSuffix("webp")
    }
}

public struct ShortVideoImage: Codable {
    /// 宽度
    let width: Int
    /// 高度
    let height: Int
    /// 视频播放地址
    let urls: [ShortVideoUrl]
}

public struct ShortVideoAuthor: Codable {
    /// ID
    let id: String
    /// 昵称
    let nickname: String
    /// 头像
    let headUrls: [ShortVideoUrl]
    /// 性别
    let gender: String
    /// 生日
    let birthday: String
    /// 介绍
    let introduction: String
}
