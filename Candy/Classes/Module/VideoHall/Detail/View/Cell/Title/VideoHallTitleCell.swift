//
//  VideoHallTitleCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/20.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoHallTitleCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var titleLabel: Label!
    @IBOutlet private weak var subTitleLabel: Label!

    public var item: VideoHallDetailModel? {
        didSet {

            guard let item = item else { return }
            titleLabel.text = item.album.title
            let sub = "\(item.album.tag_list.joined(separator: "·"))·\(item.album.area_list.joined(separator: "·"))"
            subTitleLabel.text = !item.album.bottom_label.isEmpty ? "\(item.album.year)·\(item.album.bottom_label)·\(sub)" : "\(item.album.year)·\(sub)"
        }
    }
}
