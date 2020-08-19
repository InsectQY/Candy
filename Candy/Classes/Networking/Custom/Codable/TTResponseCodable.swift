//
//  TTResponseCodable.swift
//  Candy
//
//  Created by QY on 2020/1/15.
//  Copyright © 2020 Insect. All rights reserved.
//

// MARK: - 用于今日头条返回 JSON 的解析

import RxSwift
import Moya
import CleanJSON

public extension Response {

    /// 解析出项目基类 Model
    /// - Parameter type: Model 基类中 data 的类型
    func mapTTModel<T: Codable>(_ type: T.Type) throws -> TTModel<T> {

        let decoder = CleanJSONDecoder()
        /// 当 JSON 的 Value 是 JSON 字符串的时候也开启解析
        decoder.jsonStringDecodingStrategy = .all
        let response = try mapObject(TTModel<T>.self,
                                     atKeyPath: nil,
                                     using: decoder)
        return response
    }

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapTTModelData<T: Codable>(_ type: T.Type) throws -> T {
        return try mapTTModel(T.self).data
    }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /// 解析出项目 Model 基类
    /// - Parameter type: Model 基类中 data 的类型
    func mapTTModel<T: Codable>(_ type: T.Type) -> Single<TTModel<T>> {

        return map {

            guard
                let response = try? $0.mapTTModel(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapTTModelData<T: Codable>(_ type: T.Type) -> Single<T> {

        return map {

            guard
                let response = try? $0.mapTTModelData(type)
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
    func mapTTModel<T: Codable>(_ type: T.Type) -> Observable<TTModel<T>> {

        return map {

            guard
                let response = try? $0.mapTTModel(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }

    /// 直接解析出项目 Model 基类中的 data
    /// - Parameter type: Model 基类中 data 的类型
    func mapTTModelData<T: Codable>(_ type: T.Type) -> Observable<T> {

        return map {

            guard
                let response = try? $0.mapTTModelData(type)
            else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
}
