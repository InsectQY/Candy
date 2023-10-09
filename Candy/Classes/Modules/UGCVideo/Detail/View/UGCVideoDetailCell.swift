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

    public var item: UGCListModel? {
        didSet {

            guard let item else { return }
            if item.width > item.height {
                coverImage.contentMode = .scaleAspectFit
                coverImage.clipsToBounds = false
            } else {
                coverImage.contentMode = .scaleAspectFill
                coverImage.clipsToBounds = true
            }
            coverImage.qy_setImage(item.imageUrl)
            bgImage.qy_setImage(item.imageUrl)
            abstractLabel.text = item.caption
            userNameLabel.text = item.profileInstance.name
            avatarImage.qy_setImage(item.profileInstance.avatarUrl)
            hero.id = item.shortcode
        }
    }

    // MARK: - 点击头像
    @objc private func avatarTap() {

    }

    // MARK: - 点击评论
    @IBAction private func commentBtnDidClick() {

        let vc = UGCVideoCommentViewController(id: item?.shortcode, commentCount: 0)
        let animator = JellyManager.UGCVideoComment()
        animator.prepare(presentedViewController: vc)
        parentVC?.present(vc, animated: true, completion: nil)
    }
}
