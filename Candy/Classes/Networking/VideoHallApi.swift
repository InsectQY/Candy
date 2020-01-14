//
//  VideoHallApi.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//  swiftlint:disable force_unwrapping

import Moya

enum VideoHallApi {

    /// 视频分类
    case category
    /// 视频列表(参数: 当前加载数量, 加载类别)
    case list(Int, String)
    /// 视频详情
    case detail(albumID: String, episodeID: String)
    /// 搜索建议
    case searchSug(String)
    /// 搜索结果(参数: 当前加载数量, 加载类别)
    case search(Int, String)
    /// 放映厅视频真实播放地址()
    case parseVideoHall(vid: String, ptoken: String, author: String)
}

extension VideoHallApi: TargetType {

    var baseURL: URL {

        switch self {
        case .parseVideoHall:
            return URL(string: Configs.Network.touTiaoBaseUrl)!
        default:
            return URL(string: Configs.Network.yangGuangUrl)!
        }
    }

    var path: String {
        switch self {
        case .category:
            return "lvideo/filter/"
        case .list:
            return "lvideo/index/"
        case .detail:
            return "lvideo/info/"
        case .searchSug:
            return "search/sug/"
        case .search:
            return "lvideo/search/"
        case .parseVideoHall:
            return "video/openapi/v1/"
        }
    }

    var task: Task {

        var parameters = ParameterManger.shared.YGParameter()
        switch self {
        case .category:
            parameters["category"] = "subv_xg_lvideo_recommend"
        case let .list(offset, key):

            parameters["limit"] = 16
            parameters["offset"] = offset
            parameters["search_keys"] = key
            parameters["category"] = "subv_xg_lvideo_recommend"
        case let .detail(albumID, episodeID):

            parameters["album_id"] = albumID
            parameters["episode_id"] = episodeID
        case let .searchSug(keyword):

            parameters["keyword"] = keyword
        case let .search(offset, keyword):

            parameters["keyword"] = keyword
            parameters["offset"] = offset
            parameters["m_tab"] = "long_video"
            parameters["format"] = "json"
            parameters["channel"] = "local_test"
            parameters["count"] = 50
            parameters["cur_tab"] = 2
            parameters["en_qc"] = 1
        case let .parseVideoHall(videoID, token, _):

            parameters["action"] = "GetPlayInfo"
            parameters["video_id"] = videoID
            parameters["ptoken"] = token
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        switch self {
        case let .parseVideoHall(_, _, author):
            return ["Authorization": author]
        default:
            return nil
        }
    }
}
