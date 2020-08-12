//
//  VideoHallTitleCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/20.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallTitleCell: TableViewCell {

    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var subTitleLabel: Label!

    public var item: VideoHallDetailModel? {
        didSet {

            guard let item = item else { return }
            titleLabel.text = item.Album.title
            let sub = "\(item.Album.tag_list.joined(separator: "·"))·\(item.Album.area_list.joined(separator: "·"))"
            subTitleLabel.text = !item.Album.bottom_label.isEmpty ? "\(item.Album.year)·\(item.Album.bottom_label)·\(sub)" : "\(item.Album.year)·\(sub)"
        }
    }
}
