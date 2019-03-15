//
//  NavigationMap.swift
//  SSDispatch
//
//  Created by insect_qy on 2018/7/26.
//  Copyright © 2018年 insect_qy. All rights reserved.
//

import URLNavigator

public let navigator = NavigationMap.default

struct NavigationMap {
    static fileprivate let `default` = Navigator()

    static func initRouter() {

        VideoURL.initRouter()
        VideoHallURL.initRouter()
        UserURL.initRouter()
        UGCURL.initRouter()
    }
}
