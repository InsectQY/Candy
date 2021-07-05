//
//  UserProfileHeaderView.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileHeaderView: View {

    @IBOutlet private weak var diggCountLabel: Label!
    @IBOutlet private weak var followersCountLabel: Label!
    @IBOutlet private weak var followingCountLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView!

    public var item: UserProfileModel? {
        didSet {

            guard let item = item else { return }
            diggCountLabel.text = item.userInfo.heartCountString
            followersCountLabel.text = item.userInfo.followerCountString
            followingCountLabel.text = item.userInfo.followingCountString
            var options: [KingfisherOptionsInfoItem] = []
            if item.userInfo.headUrls.first?.isWebP ?? false {
                options += [KfWebPOptions.webp(),
                            KfWebPOptions.webpCache()]
            }
            avatarImage.qy_setImage(item.userInfo.headUrls.first?.url,
                                    placeholder: R.image.avatar(),
                                    options: options)
        }
    }
}

// MARK: - Reactive-Extension
extension Reactive where Base: UserProfileHeaderView {

    var item: Binder<UserProfileModel?> {

        Binder(base) { target, value in
            target.item = value
        }
    }
}
