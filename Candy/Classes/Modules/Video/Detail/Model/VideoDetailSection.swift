//
//  VideoDetailSection.swift
//  QYNews
//
//  Created by Insect on 2019/1/31.
//  Copyright © 2019 Insect. All rights reserved.
//

import RxDataSources

enum VideoDetailSection {

    case info(_ items: [VideoDetailItem])
    case related(_ items: [VideoDetailItem])
    case comment(_ items: [VideoDetailItem])
}

enum VideoDetailItem {

    case info(_ item: NewsModel)
    case related(_ item: NewsModel)
    case comment(_ item: ShortVideoCommentItem)
}

extension VideoDetailSection: SectionModelType {

    typealias Item = VideoDetailItem

    var items: [Item] {
        switch self {
        case let .info(elements):
            return elements.map { $0 }
        case let .related(elements):
            return elements.map { $0 }
        case let .comment(elements):
            return elements.map { $0 }
        }
    }

    init(original: VideoDetailSection, items: [Item]) {

        switch original {
        case let .info(items):
            self = .info(items)
        case let .related(items):
            self = .info(items)
        case let .comment(items):
            self = .info(items)
        }
    }
}
