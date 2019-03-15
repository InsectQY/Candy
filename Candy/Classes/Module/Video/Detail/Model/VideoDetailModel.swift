//
//  VideoDetailModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

class VideoDetailModel: Codable {

    /// 相关新闻
    let related_video_toutiao: [NewsModel]
    /// 发布人信息
    let media_info: MediaInfo
}
