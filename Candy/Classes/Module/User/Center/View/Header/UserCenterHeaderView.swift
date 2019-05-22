//
//  UserCenterHeaderView.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import MonkeyKing

class UserCenterHeaderView: UIView {

    public static let height: CGFloat = 150

    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private(set) weak var nameBtn: Button!

    override func awakeFromNib() {
        super.awakeFromNib()
        item = userManager.userInfo
    }

    public var item: UserInfoModel? {
        didSet {

            guard let item = item else { return }

            let imageSize = CGSize(width: 80 * UIScreen.main.scale, height: 80 * UIScreen.main.scale)
            avatarImage.qy_setImage(item.headimgurl, options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            nameBtn.setTitle(item.nickname, for: .normal)
        }
    }
}

// MARK: - Reactive
extension Reactive where Base: UserCenterHeaderView {

    var userInfo: Binder<UserInfoModel> {
        return Binder(base) { view, result in
            view.item = result
        }
    }
}
