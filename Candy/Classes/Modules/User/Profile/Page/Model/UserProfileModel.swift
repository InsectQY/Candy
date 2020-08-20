//
//  UserProfileModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/2.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

public struct UserProfileModel: Codable {
    /// 用户信息
    let userInfo: ShortVideoUser
    /// 用户视频
    let works: UserProfileWork
}

public struct UserProfileWork: Codable {
    /// 视频
    let items: [ShortVideoItem]
    /// 分页标识
    let nextCursor: String
}

public struct ShortVideoUser: Codable {
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
    /// 关注数
    let followingCnt: Int
    /// 粉丝数
    let followerCnt: Int
    /// 获赞数
    let heartCnt: Int

    var followingCountString: String {
        followingCnt.countString
    }

    var followerCountString: String {
        followerCnt.countString
    }

    var heartCountString: String {
        heartCnt.countString
    }
}
