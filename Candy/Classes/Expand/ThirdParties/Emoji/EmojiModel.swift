//
//  EmojiModel.swift
//  QYNews
//
//  Created by Insect on 2018/12/12.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation

struct Emoji {

    var id = ""
    var name = ""
    var png = ""
    var isDelete = false
    var isEmpty = false

    init(id: String = "", name: String = "", png: String = "", isDelete: Bool = false, isEmpty: Bool = false) {
        self.id = id
        self.name = name
        self.png = png
        self.isDelete = isDelete
        self.isEmpty = isEmpty
    }
}
