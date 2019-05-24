//
//  UGCVideoCommentHeaderView.swift
//  Candy
//
//  Created by Insect on 2019/4/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UGCVideoCommentHeaderView: View {

    static let height: CGFloat = 55

    @IBOutlet private weak var commentCountLabel: Label!
    public var count: Int? {
        didSet {
            guard let count = count else { return }
            commentCountLabel.text = "\(count)条评论"
        }
    }

    @IBAction func closeBtnDidClick(_ sender: Any) {
        viewContainingController()?.dismiss(animated: true,
                                            completion: nil)
    }
}
