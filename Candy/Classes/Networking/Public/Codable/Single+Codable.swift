//
//  PrimitiveSequence + Codable.swift
//  GamerSky
//
//  Created by QY on 2018/5/5.
//  Copyright © 2018年 QY. All rights reserved.
//

import RxSwift
import Moya
import CleanJSON

// MARK: - 通用封装
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /// Moya 解析 JSON 的 RxSwift 扩展
    /// - Parameters:
    ///   - type: Model 的类型
    ///   - path: 指定解析 JSON 的路径
    ///   - decoder: 解析器 (默认使用 CleanJSONDecoder 作为解析器)
    ///   - failsOnEmptyData: 在返回数据为空的情况下是否抛出异常
    func mapObject<D: Decodable>(_ type: D.Type,
                                 atKeyPath path: String? = nil,
                                 using decoder: JSONDecoder = CleanJSONDecoder(),
                                 failsOnEmptyData: Bool = true) -> Single<D> {
        return map {

            guard
                let response = try? $0.mapObject(type,
                                                 atKeyPath: path,
                                                 using: decoder,
                                                 failsOnEmptyData: failsOnEmptyData)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
}
