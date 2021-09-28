//
//  String+Style.swift
//  Candy
//
//  Created by Insect on 2021/9/28.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

public extension String {

    var emptyDataSetDescAttributed: NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    var emptyDataSetTitleAttributed: NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }
}
