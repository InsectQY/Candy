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

    convenience init(_ placeHoder: String) {

        self.init(hotSearches: nil, searchBarPlaceholder: placeHoder)

        self.hotSearches = ["无间道", "放牛班的春天", "英雄本色", "大鱼", "血战钢锯岭", "九品芝麻官", "士兵突击", "大宋提刑官", "罗马假日", "我的团长我的团"]
        self.delegate = self
        self.hotSearchStyle = .arcBorderTag
        self.searchHistoryStyle = .arcBorderTag
        self.didSearchBlock = { _, _, searchText in
            navigator.push(VideoHallURL.searchResult.path, context: searchText ?? "")
        }
    }
}

// MARK: - PYSearchViewControllerDelegate
extension VideoHallSearchViewController: PYSearchViewControllerDelegate {

    func searchViewController(_ searchViewController: PYSearchViewController!, searchTextDidChange searchBar: UISearchBar!, searchText: String!) {

        VideoHallApi.searchSug(searchText)
        .request()
        .mapObject([String].self)
        .asDriver(onErrorJustReturn: [])
        .drive(rx.searchSuggestions)
        .disposed(by: rx.disposeBag)
    }

    func searchViewController(_ searchViewController: PYSearchViewController!, didSelectSearchSuggestionAt indexPath: IndexPath!, searchBar: UISearchBar!) {
        navigator.push(VideoHallURL.searchResult.path, context: searchSuggestions[indexPath.row])
    }
}

// MARK: - Reactive-extension
extension Reactive where Base: VideoHallSearchViewController {

    var searchSuggestions: Binder<[String]> {

        return Binder(base) { vc, result in
            vc.searchSuggestions = result
        }
    }
}
