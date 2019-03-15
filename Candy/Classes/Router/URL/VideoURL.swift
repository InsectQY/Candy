//
//  VideoURL.swift
//  QYNews
//
//  Created by Insect on 2019/1/31.
//  Copyright © 2019 Insect. All rights reserved.
//

import URLNavigator

enum VideoURL {

    /// 视频详情
    case detail
}

extension VideoURL {

    var path: String {

        switch self {

        case .detail:
            return "navigator://VideoURL/detail"
        }
    }

    static func initRouter() {

        navigator.register(VideoURL.detail.path) { url, values, context in

            guard let context = context as? [String: Any],
                let video = context[newsTypedKey] else {
                return nil
            }

            let seekTime = context[seekTimeTypedKey] ?? 0
            let vc = VideoDetailViewController(video: video, seekTime: seekTime)
            return vc
        }
    }
}
