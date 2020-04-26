//
//  DefaultsKeyExtension.swift
//  Motion
//
//  Created by QY on 2018/11/19.
//  Copyright © 2018年 Insect. All rights reserved.
//

import DefaultsKit

extension DefaultsKey {

    static let userKey = Key<UserInfoModel>("QYUserInfo")

    static func historyKey(videoID: String) -> Key<PlayHistory> {
        Key<PlayHistory>(videoID)
    }
}
