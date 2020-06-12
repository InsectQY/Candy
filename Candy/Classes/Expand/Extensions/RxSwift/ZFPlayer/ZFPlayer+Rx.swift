//
//  ZFPlayer+Rx.swift
//  Candy
//
//  Created by Insect on 2019/5/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import ZFPlayer

extension Reactive where Base: ZFPlayerController {

    public var assetURLs: Binder<[URL]?> {
        Binder(self.base) { player, urls in
            player.assetURLs = urls
        }
    }

    public var assetURL: Binder<URL> {
         Binder(self.base) { player, url in
            player.assetURL = url
        }
    }

    public var stop: Binder<Void> {
         Binder(self.base) { player, _ in
            player.stop()
        }
    }

    public func playTheIndexPath(scrollToTop: Bool = false) -> Binder<IndexPath> {
         Binder(base) { player, indexPath in
            player.playTheIndexPath(indexPath)
        }
    }

    public func seek(toTime time: TimeInterval,
                     completionHandler: ((Bool) -> Void)? = nil) -> Binder<Void> {
         Binder(base) { player, _ in
            player.seek(toTime: time,
                        completionHandler: completionHandler)
        }
    }
}

extension Reactive where Base: ZFPlayerControlView {

    public func showTitle(_ title: String,
                          coverURLString: String,
                          fullScreenMode: ZFFullScreenMode) -> Binder<Void> {
         Binder(base) { controlView, _ in
            controlView.showTitle(title,
                                  coverURLString: coverURLString,
                                  fullScreenMode: fullScreenMode)
        }
    }
}
