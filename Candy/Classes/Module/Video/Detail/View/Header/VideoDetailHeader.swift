//
//  VideoDetailHeader.swift
//  QYNews
//
//  Created by Insect on 2018/12/11.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class VideoDetailHeader: View {

    static let height: CGFloat = ScreenHeight * 0.4
    static let bottomHeight: CGFloat = 55

    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private(set) weak var videoContainerView: View!
    @IBOutlet private weak var nameLabel: Label!

    public var video: NewsModel? {
        didSet {

            guard let video = video else { return }
            nameLabel.text = video.user_info.name
            let imageSize = CGSize(width: 40 * UIScreen.main.scale, height: 40 * UIScreen.main.scale)
            avatarImage.qy_setImage(video.user_info.avatar_url, placeholder: "avatar", options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
        }
    }

    @IBAction private func backBtnDidClick(_ sender: Any) {
        parentVC?.navigationController?.popViewController(animated: true)
    }
}
