//
//  UserProfileHeaderView.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserProfileHeaderView: View, NibLoadable {

    @IBOutlet private weak var diggCountLabel: Label!
    @IBOutlet private weak var followersCountLabel: Label!
    @IBOutlet private weak var followingCountLabel: Label!
    @IBOutlet private weak var publishCountLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!

    public var item: UserProfileModel? {
        didSet {

            guard let item = item else { return }

            diggCountLabel.text = item.diggCountString
            followersCountLabel.text = item.followersCountString
            followingCountLabel.text = item.followingsCountString
            publishCountLabel.text = item.publishCountString
            let imageSize = CGSize(width: 80 * UIScreen.main.scale, height: 80 * UIScreen.main.scale)
            avatarImage.qy_setImage(item.avatar_url, options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
        }
    }
}
