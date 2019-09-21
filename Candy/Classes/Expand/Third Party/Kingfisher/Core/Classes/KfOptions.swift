//
//  KfOptions.swift
//  QYNews
//
//  Created by Insect on 2018/12/19.
//  Copyright © 2018 Insect. All rights reserved.
//

import Foundation
import Kingfisher

public class KfOptions {

    public static func corner(_ cornerRadius: CGFloat, targetSize: CGSize? = nil) -> KingfisherOptionsInfoItem {

        let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius, targetSize: targetSize)
        return KingfisherOptionsInfoItem.processor(processor)
    }

    public static func resize(_ referenceSize: CGSize, mode: ContentMode = .none) -> KingfisherOptionsInfoItem {

        let processor = ResizingImageProcessor(referenceSize: referenceSize, mode: mode)
        return KingfisherOptionsInfoItem.processor(processor)
    }

    public static func crop(_ size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> KingfisherOptionsInfoItem {

        let processor = CroppingImageProcessor(size: size, anchor: anchor)
        return KingfisherOptionsInfoItem.processor(processor)
    }

    public static func fadeTransition(_ time: TimeInterval) -> KingfisherOptionsInfoItem {
        return KingfisherOptionsInfoItem.transition(.fade(time))
    }
}
