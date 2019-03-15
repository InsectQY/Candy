//
//  UserInfoModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

struct UserInfoModel: Codable {

    /// ID
    var openid: String = ""
    var unionid: String = ""
    /// 用户名
    var nickname: String = ""
    /// 图片
    var headimgurl: String = ""
}

/// 播放历史
struct PlayHistory: Codable {

    /// 视频 ID
    var videoID: String
    /// 单集 ID
    var episodeID: String
    /// 播放到了第几集
    var episodeIndex: Int
    /// 播放的位置
    var time: Int
}
