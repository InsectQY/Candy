//
//  KKResponseCodable.swift
//  Candy
//
//  Created by Insect on 2020/8/19.
//  Copyright © 2020 Insect. All rights reserved.
//
// MARK: - 用于快看视频返回 JSON 的解析

import RxSwift
import Moya
import CleanJSON

public extension Response {

    /// 解析出项目基类 Model
    /// - Parameter type: Model 基类中 data 的类型
    func mapKKModel<T: Codable>(_ type: T.Type) throws -> KKModel<T> {

        let decoder = CleanJSONDecoder()
        /// 当 JSON 的 Value 是 JSON 字符串的时候也开启解析
        decoder.jsonStringDecodingStrategy = .all
        let response = try mapObject(KKModel<T>.self,
                                     atKeyPath: nil,
                                     using: decoder)
        return response
    }

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapKKModelData<T: Codable>(_ type: T.Type) throws -> T {
        return try mapKKModel(T.self).data
    }

    /// 解析出评论数据
    func mapKKComment() throws -> ShortVideoComment {

        var kkModelData = try mapKKModelData(ShortVideoComment.self)

        let json: [String: Any]? = try mapJSON() as? [String: Any]
        let data: [String: Any]? = json?["data"] as? [String: Any]
        let cmtMap: [String: Any]? = data?["cmtMap"] as? [String: Any]
        for item in kkModelData.rootCmts {
            if let commentJSON = cmtMap?[item] {
                let data = try JSONSerialization.data(withJSONObject: commentJSON,
                                                      options: .fragmentsAllowed)
                let comment = try CleanJSONDecoder().decode(ShortVideoCommentItem.self,
                                                            from: data)
                kkModelData.comments.append(comment)
            }
        }
        return kkModelData
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /// 解析出项目 Model 基类
    /// - Parameter type: Model 基类中 data 的类型
    func mapKKModel<T: Codable>(_ type: T.Type) -> Single<KKModel<T>> {

        return map {

            guard
                let response = try? $0.mapKKModel(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapKKModelData<T: Codable>(_ type: T.Type) -> Single<T> {

        return map {

            guard
                let response = try? $0.mapKKModelData(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }

    func mapKKComment() -> Single<ShortVideoComment> {

        return map {

            guard
                let response = try? $0.mapKKComment()
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
}

public extension ObservableType where Element == Response {

    /// 解析出项目 Model 基类
    /// - Parameter type: Model 基类中 data 的类型
    func mapKKModel<T: Codable>(_ type: T.Type) -> Observable<KKModel<T>> {

        return map {

            guard
                let response = try? $0.mapKKModel(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapKKModelData<T: Codable>(_ type: T.Type) -> Observable<T> {

        return map {

            guard
                let response = try? $0.mapKKModelData(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }

    func mapKKComment() -> Observable<ShortVideoComment> {

        return map {

            guard
                let response = try? $0.mapKKComment()
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
}
