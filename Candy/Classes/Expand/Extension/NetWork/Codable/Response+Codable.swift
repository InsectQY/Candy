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

public extension Response {

    public func mapObject<T: Codable>(_ type: T.Type, atKeyPath path: String? = nil, using decoder: JSONDecoder = CleanJSONDecoder(), failsOnEmptyData: Bool = true) throws -> T {

        do {
            return try map(type, atKeyPath: path, using: decoder, failsOnEmptyData: failsOnEmptyData)
        } catch {
            throw MoyaError.objectMapping(error, self)
        }
    }

    public func mapObject<T: Codable>(_ type: T.Type, using decoder: JSONDecoder = CleanJSONDecoder()) throws -> T {

        let response = try mapObject(Model<T>.self, atKeyPath: nil, using: decoder)
        return response.data
    }
}
