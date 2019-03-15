//
//  IntExtension.swift
//  GamerSky
//
//  Created by QY on 2018/5/3.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation

extension Int {

    public var timeFormat: String {

        let timeDate = Date(timeIntervalSince1970: TimeInterval(self / 1000))
        var timeInterval = timeDate.timeIntervalSinceNow

        timeInterval = -timeInterval
        let section = Int(timeInterval)
        let minute = section / 60
        let hour = minute / 60
        let day = hour / 24

        var result = ""

        if timeInterval < 60 {
            result = "刚刚"
        } else if minute < 60 {
            result = "\(minute)分钟前"
        } else if hour < 24 {
            result = "\(hour)小时前"
        } else if day <= 7 {
            result = "\(day)天前"
        } else {
            result = timeDate.string(withFormat: "MM-dd HH:mm")
        }

        return result
    }

    /// 数量超过1万以后显示的内容
    public var countString: String {
        return self / 10000 >= 1 ? "\(self / 10000)万" : "\(self)"
    }

    /// 视频时长
    public var timeDuration: String {

        let minute = self / 60
        let hour = minute / 60
        let second = String(format: "%02d", self % 60)

        if minute < 60 { // 视频时长小于一小时
            return "\(String(format: "%02d", minute)):\(second)"
        } else { // 视频时长超过一小时
            return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(second)"
        }
    }
}
