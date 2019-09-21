//
//  UGCVideoDetailCell.swift
//  QYNews
//
//  Created by Insect on 2018/12/12.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit

class UGCVideoDetailCell: CollectionViewCell {

    /// 是否触发了下滑手势
    public var isPanned: Bool = false {
        didSet {
            abstractLabel.isHidden = isPanned
            userNameLabel.isHidden = isPanned
            avatarImage.isHidden = isPanned
            commentBtn.isHidden = isPanned
            bgImage.isHidden = isPanned
        }
    }

    @IBOutlet private weak var abstractLabel: Label!
    @IBOutlet private weak var userNameLabel: Label!
    @IBOutlet private weak var avatarImage: ImageView! {
        didSet {
            avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTap)))
        }
    }
    @IBOutlet private(set) weak var coverImage: ImageView!
    @IBOutlet private(set) weak var bgImage: ImageView!
    @IBOutlet private weak var commentBtn: Button!
    @IBOutlet private weak var shareBtn: Button!

    public var item: UGCVideoListModel? {

        didSet {

            guard let item = item?.content else { return }

            if (item.raw_data.large_image_list.first?.width ?? 0) > (item.raw_data.large_image_list.first?.height ?? 0) {
                coverImage.contentMode = .scaleAspectFit
                coverImage.clipsToBounds = false
            } else {
                coverImage.contentMode = .scaleAspectFill
                coverImage.clipsToBounds = true
            }
            coverImage
            .qy_setImage(item.raw_data.video.origin_cover.url_list.first)
            bgImage
            .qy_setImage(item.raw_data.video.origin_cover.url_list.first)
            abstractLabel.text = item.raw_data.title
            userNameLabel.text = item.raw_data.user.info.name
            avatarImage
            .qy_setImage(item.raw_data.user.info.avatar_url)
            commentBtn.setTitle(item.raw_data.action.commentCountString, for: .normal)
            hero.id = item.raw_data.item_id
        }
    }

    // MARK: - 点击头像
    @objc private func avatarTap() {

        return
        let vc = UserPorfileViewController(userID: item?.content.raw_data.user.info.user_id ?? "")
        let nav = NavigationController(rootViewController: vc)
        parentVC?.present(nav, animated: true, completion: nil)
    }

    // MARK: - 点击评论
    @IBAction private func commentBtnDidClick(_ sender: Any) {

        let vc = UGCVideoCommentViewController(item: item)
        let animator = JellyManager.UGCVideoComment()
        animator.prepare(presentedViewController: vc)
        parentVC?.present(vc, animated: true, completion: nil)
    }
}
