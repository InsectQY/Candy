//
//  ImageCell.swift
//  QYNews
//
//  Created by Insect on 2019/1/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet private weak var largeImage: ImageView!

    public var item: String? {

        didSet {
            largeImage.qy_setImage(item)
        }
    }
}
