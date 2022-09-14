//
//  ReplyCommentTopView.swift
//  Candy
//
//  Created by Insect on 2019/4/4.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class ReplyCommentTopView: UIView {

    static let height: CGFloat = 55

    // MARK: - IBOutlet
    @IBOutlet private weak var commentCountLabel: Label!

    @IBAction func closeBtnDidClick(_ sender: Any) {
        parentVC?.dismiss(animated: true, completion: nil)
    }

    public var count: Int? {
        didSet {
            guard let count else { return }
            commentCountLabel.text = "\(count)条评论"
        }
    }
}
