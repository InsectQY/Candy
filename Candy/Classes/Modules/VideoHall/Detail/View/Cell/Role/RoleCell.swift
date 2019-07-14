//
//  RoleCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/21.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class RoleCell: CollectionViewCell {

    @IBOutlet private weak var nameLabel: Label!
    @IBOutlet private weak var profileImage: ImageView!

    public var item: Role? {
        didSet {

            nameLabel.text = item?.name
            let options = [KfWebPOptions.webp(),
                           KfWebPOptions.webpCache(),
                           KfOptions.fadeTransition(Configs.Time.imageTransition)]
            profileImage
            .qy_setImage(item?.profile_photo_list.first?.url,
                         placeholder: R.image.avatar(),
                         options: options)
        }
    }
}
