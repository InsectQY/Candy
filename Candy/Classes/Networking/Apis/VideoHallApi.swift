//
//  VideoHallApi.swift
//  QYNews
//
//  Created by Insect on 2018/12/18.
//  Copyright © 2018 Insect. All rights reserved.
//  swiftlint:disable force_unwrapping

import Moya

/// 放映厅请求
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
}

extension VideoHallApi: TargetType {

    var baseURL: URL {
        URL(string: Configs.Network.yangGuangUrl)!
    }

    var path: String {
        switch self {
        case .category:
            return "xigua/filter/"
        case .list:
            return "xigua/cosmos/"
        case .detail:
            return "xigua/video/"
        case .searchSug:
            return "search/sug/"
        case .search:
            return "xigua/search/"
        }
    }

    var task: Task {
        var parameters = ParameterManger.shared.YGParameter()
        switch self {
        case .category:
            break
        case let .list(offset, searchKey):

            parameters["offset"] = offset
            parameters["FilterWordList"] = searchKey
        case let .detail(albumID, episodeID):

            parameters["AlbumGid"] = albumID
            parameters["EpisodeGid"] = episodeID
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
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
}

//extension VideoHallApi: YGRespnseHandle {}
