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

    public var item: ShortVideoItem? {
        didSet {

            guard let item = item else { return }
            if item.videoInfo.coverImg.width > item.videoInfo.coverImg.height {
                coverImage.contentMode = .scaleAspectFit
                coverImage.clipsToBounds = false
            } else {
                coverImage.contentMode = .scaleAspectFill
                coverImage.clipsToBounds = true
            }
            let imageURL = item.videoInfo.coverImg.urls.first?.url
            coverImage.qy_setImage(imageURL)
            bgImage.qy_setImage(imageURL)
            abstractLabel.text = item.caption
            userNameLabel.text = item.authorInfo.nickname
            avatarImage.qy_setImage(item.authorInfo.headUrls.first?.url)
            hero.id = item.itemId
        }
    }

    // MARK: - 点击头像
    @objc private func avatarTap() {

        guard let item = item else { return }
        let vc = UserPorfileViewController(userID: item.authorInfo.id)
        parentVC?.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - 点击评论
    @IBAction private func commentBtnDidClick(_ sender: Any) {

        let vc = UGCVideoCommentViewController(id: item?.itemId, commmentCount: item?.cmtCnt)
        let animator = JellyManager.UGCVideoComment()
        animator.prepare(presentedViewController: vc)
        parentVC?.present(vc, animated: true, completion: nil)
    }
}
