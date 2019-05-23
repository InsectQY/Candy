//
//  SearchTitleView.swift
//  QYNews
//
//  Created by Insect on 2019/1/8.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class SearchTitleView: UIView {

    public static let x: CGFloat = 20
    public static let y: CGFloat = 5
    public static let height: CGFloat = 34
    public static let width: CGFloat = Configs.Dimensions.screenWidth - x * 2

    public let beginEdit = PublishSubject<Void>()

    private lazy var searchTF: TextField = {

        let searchTF = TextField(frame: bounds)
        searchTF.borderStyle = .roundedRect
        searchTF.font = .pingFangSCRegular(15)
        searchTF.text = R.string.localizable.videoHallSearchPlaceholder()
        searchTF.leftViewMode = .always
        searchTF.leftView?.origin = CGPoint(x: 10, y: 0)
        let image = UIButton(type: .custom)
        image.setImage(R.image.search_24x24_(), for: .normal)
        image.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        searchTF.leftView = image
        searchTF.delegate = self
        return searchTF
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchTF)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}

extension SearchTitleView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        beginEdit.onNext(())
        return false
    }
}
