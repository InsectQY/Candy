//
//  Filter.swift
//  BookShopkeeper
//
//  Created by QY on 2018/4/24.
//  Copyright © 2018年 dingding. All rights reserved.
//

import UIKit

struct BaseCategory: Codable {
    let search_category_info: CategoryInfo
}

struct CategoryInfo: Codable {

    let search_category_list: [CategoryList]
}

struct CategoryList: Codable {

    let name: String
    let search_category_word_list: [Filter]
}

struct Filter: Codable {

    let name: String
    let search_key: String
}
