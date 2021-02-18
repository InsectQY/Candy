//
//  EpisodePageViewModel.swift
//  Candy
//
//  Created by Insect on 2021/2/18.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

final class EpisodePageViewModel: ViewModel, NestedViewModelable {

    /// 每页最多显示的集数
    private let maxPageCount = 50

    let input: Input
    let output: Output
    
    struct Input {
        /// 总共有多少集
        let totalCount: Int
    }

    struct Output {
        let items: [TitleEpisodePage]
        let titles: [String]
    }

    init(totalCount: Int) {

        input = Input(totalCount: totalCount)

        var list: [TitleEpisodePage] = []
        var titles: [String] = []
        // 一共有多少页
        let page = input.totalCount / maxPageCount
        // 最后一页有多少集(比如一共 120集 120 % 50 = 20，一共3集 3 % 50 = 3)
        let lastPageCount = input.totalCount % maxPageCount

        for i in 0..<page {

            let start = i * maxPageCount
            let end = (i + 1) * maxPageCount
            let title = "\(start + 1)-\(end)"
            titles.append(title)
            list.append(TitleEpisodePage(start: start,
                                         end: end,
                                         title: title))
        }

        if lastPageCount > 0 { // 取模的集数
            let start = page * maxPageCount
            let end = start + lastPageCount
            // 只有一集
            let title = (start + 1) == end ? "\(start + 1)" : "\(start + 1)-\(end)"
            titles.append(title)
            list.append(TitleEpisodePage(start: start,
                                         end: end,
                                         title: title))
        }

        output = EpisodePageViewModel.Output(items: list,
                                             titles: titles)
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}
