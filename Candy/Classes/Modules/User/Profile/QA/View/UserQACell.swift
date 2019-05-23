//
//  UserQACell.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserQACell: TableViewCell {

    private let margin: CGFloat = 2

    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: CollectionView! {
        didSet {
            collectionView.register(R.nib.imageCell)
        }
    }
    @IBOutlet private weak var avatarImage: ImageView!
    @IBOutlet private weak var nameLabel: Label!
    @IBOutlet private weak var subTitleLabel: Label!
    @IBOutlet private weak var questionLabel: Label!
    @IBOutlet private weak var answerLabel: Label!
    @IBOutlet private weak var shareBtn: Button!
    @IBOutlet private weak var commentBtn: Button!
    @IBOutlet private weak var diggBtn: Button!

    public var item: QAModel? {

        didSet {

            guard let item = item?.content.raw_data.content else { return }

            collectionView.reloadData()

            let imageSize = CGSize(width: 40 * UIScreen.main.scale, height: 40 * UIScreen.main.scale)
            avatarImage.qy_setImage(item.user.avatar_url, options: [KfOptions.corner(imageSize.width * 2, targetSize: imageSize)])
            nameLabel.text = item.user.uname

            let sub = item.user.v_icon.isEmpty ? item.answer.createTimeString : item.answer.createTimeString + "·" + item.user.v_icon
            subTitleLabel.text = sub
            questionLabel.text = "回答了: \(item.question.title)"
            answerLabel.text = item.answer.abstract_text
            shareBtn.setTitle(" \(item.answer.forwardCountString)", for: .normal)
            commentBtn.setTitle(" \(item.answer.commentCountString)", for: .normal)
            diggBtn.setTitle(" \(item.answer.diggCountString)", for: .normal)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension UserQACell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.imageCell.identifier,
                                                      for: indexPath,
                                                      cellType: ImageCell.self)
        cell.item = item?.content.raw_data.content.answer.large_image_list[indexPath.item].url
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item?.content.raw_data.content.answer.large_image_list.count ?? 0
    }
}

// MARK: - UICollectionViewDelegate
extension UserQACell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserQACell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard
            let count = item?.content.raw_data.content.answer.large_image_list.count
        else {
            collectionViewHeightConstraint.constant = 0
            return .zero
        }
        var cellW: CGFloat = 0
        var cellH: CGFloat = 0
        switch count {
        case 1: // 一张图

            cellW = Configs.Dimensions.screenWidth
            cellH = Configs.Dimensions.screenWidth
        case 2: // 两张图

            cellW = (Configs.Dimensions.screenWidth - margin) / 2
            cellH = cellW * 0.8
        default: // 三张图

            cellW = (Configs.Dimensions.screenWidth - 2 * margin) / 3
            cellH = cellW * 0.8
        }
        collectionViewHeightConstraint.constant = cellH
        return CGSize(width: Configs.Dimensions.screenWidth, height: cellH)
    }
}
