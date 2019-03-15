//
//  UserProfileModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/2.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

class UserProfileModel: Codable {

    /// 用户 ID
    let user_id: String
    /// 用户名
    let name: String
    /// 头像
    let avatar_url: String
    /// 大头像
    let big_avatar_url: String
    /// 头条数
    let publish_count: Int
    /// 关注数
    let followings_count: Int
    /// 粉丝数
    let followers_count: Int
    /// 获赞数
    let digg_count: Int
    /// 认证信息
    let verified_content: String
    /// 位置
    let area: String
    /// 简介
    let description: String
    /// page 数据
    let top_tab: [TopType]

    lazy var followingsCountString = followers_count.countString

    lazy var followersCountString = followings_count.countString

    lazy var publishCountString = publish_count.countString

    lazy var diggCountString = digg_count.countString
}

class TopType: Codable {

    /// 标题
    let show_name: String
    /// 请求字段
    let type: ProfileType
    /// 请求路径
    let url: String

    lazy var category: String = {
        if url.isEmpty { return "" }
        let NSURL = (url as NSString)
        return NSURL.substring(from: NSURL.range(of: "=").location + 1)
    }()
}

enum ProfileType: String, Codable {

    /// 动态
    case all = "dongtai"
    /// 视频
    case video = "video"
    /// 文章
    case article = "all"
    /// 专栏
    case column = "column"
    /// 小视频
    case ugcVideo = "ies_video"
    /// 店铺
    case shop = "temai_shop"
    /// 问答
    case wenda = "wenda"
    /// 矩阵
    case matrix = "matrix_media_list"
    /// 发布厅
    case publishHall = "matrix_atricle_list"
}

extension ProfileType {

    func viewWith(category: String, visitedID: String) -> JXPagerViewListViewDelegate {
        switch self {
        case .all:
            return UserVideoView(category: category, visitedID: visitedID)
        case .video:
            return UserVideoView(category: category, visitedID: visitedID)
        case .article:
            return UserArticleView(category: category, visitedID: visitedID)
        case .column:
            return UserVideoView(category: category, visitedID: visitedID)
        case .ugcVideo:
            return UserUGCVideoView(category: category, visitedID: visitedID)
        case .shop:
            return UserVideoView(category: category, visitedID: visitedID)
        case .wenda:
            return UserQAView(category: category, visitedID: visitedID)
        case .matrix:
            return UserVideoView(category: category, visitedID: visitedID)
        case .publishHall:
            return UserVideoView(category: category, visitedID: visitedID)
        }
    }
}
