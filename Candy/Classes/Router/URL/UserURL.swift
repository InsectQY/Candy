//
//  UserURL.swift
//  QYNews
//
//  Created by Insect on 2019/2/1.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

enum UserURL {
    /// 分享
    case share
}

extension UserURL {

    var path: String {

        switch self {
        case .share:
            return "navigator://userURL/share"
        }
    }

    static func initRouter() {

//        navigator.register(UserURL.share.path) { (_, _, _) in
//
//            let textToShare = "不错哦~"
//            let image = UIImage(named: "Logo")!
//            let url = URL(string: "http://www.baidu.com")!
//            let vc = UIActivityViewController(activityItems: [textToShare, image, url], applicationActivities: nil)
//            return vc
//        }
    }
}
