//
//  Filter.swift
//  BookShopkeeper
//
//  Created by QY on 2018/4/24.
//  Copyright © 2018年 dingding. All rights reserved.
//

import UIKit

public struct BaseCategory: Codable {
    let search_category_info: CategoryInfo
}

public struct CategoryInfo: Codable {

    let search_category_list: [CategoryList]
}

public struct CategoryList: Codable {

    let name: String
    let search_category_word_list: [Filter]
}

public struct Filter: Codable {

    let name: String
    let search_key: String
}
