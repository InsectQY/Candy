//
//  VideoHallURL.swift
//  QYNews
//
//  Created by Insect on 2019/1/31.
//  Copyright © 2019 Insect. All rights reserved.
//

import URLNavigator

enum VideoHallURL {

    /// 放映厅详情
    case detail
    /// 搜索
    case search
    /// 搜索结果
    case searchResult
}

extension VideoHallURL {

    var path: String {

        switch self {

        case .detail:
            return "navigator://VideoHallURL/detail"
        case .search:
            return "navigator://VideoHallURL/search"
        case .searchResult:
            return "navigator://VideoHallURL/searchResult"
        }
    }

    static func initRouter() {

        navigator.register(VideoHallURL.detail.path) { url, values, context in

            guard
                let context = context as? String
            else {
                return nil
            }
            let vc = VideoHallDetailViewController(albumID: context)
            return vc
        }

        navigator.register(VideoHallURL.search.path) { url, values, context in

            guard
                let context = context as? String
            else {
                return VideoHallSearchViewController()
            }
            let vc = VideoHallSearchViewController(context)
            return vc
        }

        navigator.register(VideoHallURL.searchResult.path) { url, values, context in

            guard
                let context = context as? String
            else {
                return nil
            }
            let vc = VideoHallSearchResultViewController(keyword: context)
            return vc
        }
    }
}
