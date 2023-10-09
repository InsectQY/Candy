//
//  QYRefreshHeader.swift
//  BookShopkeeper
//
//  Created by QY on 2018/3/30.
//  Copyright © 2018年 dingding. All rights reserved.
//

import MJRefresh

extension UIScrollView {

    public var refreshHeader: MJRefreshHeader? {
        get { mj_header }
        set { mj_header = newValue }
    }

    public var refreshFooter: MJRefreshFooter? {
        get { mj_footer }
        set { mj_footer = newValue }
    }

    public var isTotalDataEmpty: Bool {
        mj_totalDataCount() == 0
    }
}

public class RefreshHeader: MJRefreshGifHeader {

}

public class RefreshFooter: MJRefreshAutoStateFooter {

    /// 初始化
    override public func prepare() {
        super.prepare()
        triggerAutomaticallyRefreshPercent = 0.5
    }
}
