//
//  HistoryManager.swift
//  QYNews
//
//  Created by Insect on 2019/1/11.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import DefaultsKit

let historyManager = HistoryManager.default

final class HistoryManager {
    static let `default` = HistoryManager()
}

extension HistoryManager {

    // MARK: - 从本地获取用户播放历史
    public static func getPlayHistory(videoID: String) -> PlayHistory? {
        Defaults().get(for: .historyKey(videoID: videoID))
    }

    // MARK: - 保存用户播放历史
    public static func saveUserInfo(_ history: PlayHistory) {
        Defaults().set(history, for: .historyKey(videoID: history.videoID))
    }

    // MARK: - 清除用户播放历史
    public static func clearPlayHistory(with videoID: String) {
        Defaults().clear(.historyKey(videoID: videoID))
    }
}

extension Reactive where Base: HistoryManager {

    var save: Binder<PlayHistory> {

        Binder(base) { _, result in
            HistoryManager.saveUserInfo(result)
        }
    }
}

extension HistoryManager: ReactiveCompatible {}
