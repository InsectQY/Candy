//
//  UserApi.swift
//  Motion
//
//  Created by QY on 2018/11/16.
//  Copyright © 2018年 Insect. All rights reserved.
//  swiftlint:disable force_unwrapping
import Moya

/// 视频 + 小视频请求
enum VideoApi {

    /// 视频分类
    case category
    /// 视频列表(参数: 视频分类)
    case list(String)
    /// 相关视频
    case related(itemID: String, groupID: String)
    /// 小视频分类
    case ugcCategory
    /// 小视频列表(参数: 视频分类)
    case ugcList(String)
    /// 小视频(活动)
    case ugcActivity(offset: Int, userAction: String)
    /// 评论详情(参数: item_id, groupid, 当前加载数量)
    case comment(itemID: String, groupID: String, offset: Int)
    /// 评论详情
    case ugcComment(groupID: String, offset: Int)
    /// 某条评论的回复
    case replyComment(id: String, offset: Int)
    /// 用户信息
    case userProfile(String)
    /// 用户某个分类下的所有数据
    case profileType(category: String, visitedID: String, offset: Int)
    /// 视频真实播放地址
    case parsePlayInfo(String)
    /// 放映厅视频真实播放地址
    case parseVideoHall(vid: String, pToken: String, author: String)
}

extension VideoApi: TargetType {

    var baseURL: URL {

        switch self {
        case .parsePlayInfo:
            return URL(string: Configs.Network.videoParseUrl)!
        default:
            return URL(string: Configs.Network.touTiaoBaseUrl)!
        }
    }

    var path: String {
        switch self {
        case .category:
            return "video_api/get_category/v3/"
        case .related:
            return "2/article/information/v24/"
        case .list:
            return "api/news/feed/v64/"
        case .ugcCategory:
            return "category/get_ugc_video/2/"
        case .ugcList:
            return "api/news/feed/v88/"
        case .comment:
            return "article/v4/tab_comments/"
        case let .parsePlayInfo(videoID):
            return "video/urls/v/1/toutiao/mp4/\(videoID)"
        case .ugcComment:
            return "article/v4/tab_comments/"
        case .replyComment:
            return "2/comment/v3/reply_list/"
        case .userProfile:
            return "user/profile/homepage/v7/"
        case .ugcActivity:
            return "ugc/video/activity/channel/v1/"
        case .parseVideoHall:
            return "video/openapi/v1/"
        default:
            return "api/feed/profile/v1/"
        }
    }

    var task: Task {

        var parameters = ParameterManger.shared.TTParameter

        switch self {
        case let .list(category):
            parameters["category"] = category
        case let .related(itemID, groupID):
            parameters["item_id"] = itemID
            parameters["group_id"] = groupID
            parameters["article_page"] = 1
        case let .ugcList(category):
            parameters["category"] = category
            parameters["list_count"] = 10
        case let .comment(itemID, groupID, offset):
            parameters["item_id"] = itemID
            parameters["group_id"] = groupID
            parameters["offset"] = offset
        case let .parsePlayInfo(videoID):

            let parse = videoID.parseVideoURL()
            return .requestParameters(parameters: ["r": parse.r,
                                                   "s": parse.s], encoding: URLEncoding.default)
        case let .ugcComment(groupID, offSet):

            parameters["group_id"] = groupID
            parameters["offset"] = offSet
            parameters["service_id"] = "1128"
        case let .replyComment(id, offset):

            parameters["id"] = id
            parameters["offset"] = offset
        case let .userProfile(id):
            parameters["user_id"] = id
        case let .profileType(category, visitedID, offset):

            parameters["category"] = category
            parameters["visited_uid"] = visitedID
            parameters["offset"] = offset
        case let .ugcActivity(offset, action):

            parameters["off_set"] = offset
            parameters["user_action"] = action
        case let .parseVideoHall(videoID, token, _):
            var parameters: [String: Any] = [:]
            parameters["action"] = "GetPlayInfo"
            parameters["video_id"] = videoID
            parameters["ptoken"] = token
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            break
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

extension VideoApi: TTResultHandle {}
