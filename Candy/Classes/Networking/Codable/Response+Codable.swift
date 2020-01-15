//
//  Response+Codable.swift
//  SSDispatch
//
//  Created by Insect on 2018/10/22.
//  Copyright © 2018 insect_qy. All rights reserved.
//

import Foundation
import Moya
import CleanJSON

// MARK: - 通用封装
public extension Response {

    /// 封装 Moya 解析 JSON 的方法，降低第三方库对项目的侵入性
    /// - Parameters:
    ///   - type: Model 的类型
    ///   - path: 指定解析 JSON 的路径
    ///   - decoder: 解析器 (默认使用 CleanJSONDecoder 作为解析器)
    ///   - failsOnEmptyData: 在返回数据为空的情况下是否抛出异常
    func mapObject<D: Decodable>(_ type: D.Type,
                                 atKeyPath path: String? = nil,
                                 using decoder: JSONDecoder = CleanJSONDecoder(),
                                 failsOnEmptyData: Bool = true) throws -> D {

        do {
            return try map(type,
                           atKeyPath: path,
                           using: decoder,
                           failsOnEmptyData: failsOnEmptyData)
        } catch {
            throw MoyaError.objectMapping(error, self)
        }
    }
}

// MARK: - 针对自己项目的封装
public extension Response {

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapModelData<T: Codable>(_ type: T.Type) throws -> T {

        let decoder = CleanJSONDecoder()
        /// 当 JSON 的 Value 是 JSON 字符串的时候也开启解析
        decoder.jsonStringDecodingStrategy = .all
        let response = try mapObject(Model<T>.self,
                                     atKeyPath: nil,
                                     using: decoder)
        return response.data
    }
}
