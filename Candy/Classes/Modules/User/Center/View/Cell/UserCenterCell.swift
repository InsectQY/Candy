//
//  UserCenterCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserCenterCell: TableViewCell {

    public static let height: CGFloat = 55

    @IBOutlet private weak var iconImage: ImageView!
    @IBOutlet private weak var titleLabel: Label!

    public var item: UserCenterModel? {
        didSet {
            guard let item = item else { return }
            iconImage.image = UIImage(named: item.icon)
            titleLabel.text = item.title
        }
    }
}
