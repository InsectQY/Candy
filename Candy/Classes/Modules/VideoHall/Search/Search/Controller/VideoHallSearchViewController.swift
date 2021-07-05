//
//  VideoHallSearchViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/8.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import PYSearch
import URLNavigator

class VideoHallSearchViewController: PYSearchViewController {

    convenience init(_ placeHolder: String? = nil) {

        self.init(hotSearches: nil, searchBarPlaceholder: placeHolder)
        self.cancelButton.setTitleColor(.white, for: .normal)
        self.hotSearches = ["无间道",
                            "放牛班的春天",
                            "英雄本色",
                            "大鱼",
                            "血战钢锯岭",
                            "九品芝麻官",
                            "士兵突击",
                            "大宋提刑官",
                            "罗马假日",
                            "我的团长我的团"]
        self.delegate = self
        self.hotSearchStyle = .arcBorderTag
        self.searchHistoryStyle = .arcBorderTag
        self.didSearchBlock = { _, _, searchText in
            navigator.push(VideoHallURL.searchResult.path,
                           context: searchText ?? "")
        }
    }
}

// MARK: - PYSearchViewControllerDelegate
extension VideoHallSearchViewController: PYSearchViewControllerDelegate {

    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange searchBar: UISearchBar!, searchText: String!) {

        VideoHallApi.searchSug(searchText)
        .request()
        .mapTTModelData([String].self)
        .asDriver(onErrorJustReturn: [])
        .drive(rx.searchSuggestions)
        .disposed(by: rx.disposeBag)
    }

    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
        navigator.push(VideoHallURL.searchResult.path,
                       context: searchSuggestions[indexPath.row])
    }
}
