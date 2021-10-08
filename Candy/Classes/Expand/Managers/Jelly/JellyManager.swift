//
//  JellyManager.swift
//  Candy
//
//  Created by QY on 2019/9/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import Jelly

class JellyManager {

    /// 剧集弹出动画
    static func episodeAnimator() -> Animator {
        /// 大小
        let size = size(height: .screenHeight - VideoHallHeaderView.height)
        let presentation = CoverPresentation(directionShow: .bottom,
                                             directionDismiss: .bottom,
                                             size: size,
                                             alignment: alignment())
        return Animator(presentation: presentation)
    }

    /// 小视频评论弹出动画
    static func UGCVideoComment() -> Animator {
        /// 大小
        let size = size(height: .screenHeight * 0.7)
        let uiConfiguration = PresentationUIConfiguration(cornerRadius: 12)
        let presentation = CoverPresentation(directionShow: .bottom,
                                             directionDismiss: .bottom,
                                             uiConfiguration: uiConfiguration,
                                             size: size,
                                             alignment: alignment())
        return Animator(presentation: presentation)
    }

    static func UGCReplyComment(presentingVc: UIViewController?) -> Animator? {

        guard let presentingVc = presentingVc else { return nil }
        let interaction = InteractionConfiguration(presentingViewController: presentingVc,
                                                   completionThreshold: 0.5,
                                                   dragMode: .canvas)
        /// 圆角
        let uiConfiguration = PresentationUIConfiguration(cornerRadius: 5)
        /// 大小
        let size = size(height: .screenHeight * 0.7)
        let presentation = CoverPresentation(directionShow: .right,
                                             directionDismiss: .right,
                                             uiConfiguration: uiConfiguration,
                                             size: size,
                                             alignment: alignment(),
                                             interactionConfiguration: interaction)
        return Animator(presentation: presentation)
    }

    static func videoReplyComment() -> Animator {
        /// 大小
        let size = size(height: .screenHeight - VideoDetailHeader.height + VideoDetailHeader.bottomHeight)
        let presentation = CoverPresentation(directionShow: .bottom,
                                             directionDismiss: .bottom,
                                             size: size,
                                             alignment: alignment())
        return Animator(presentation: presentation)
    }
}

private extension JellyManager {

    static func alignment() -> PresentationAlignment {
        PresentationAlignment(vertical: .bottom,
                              horizontal: .center)
    }

    static func size(height: CGFloat) -> PresentationSize {
        PresentationSize(width: .fullscreen,
                         height: Size.custom(value: height))
    }
}
