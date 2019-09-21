//
//  KfWebPOptions.swift
//  QYNews
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import KingfisherWebP
import Kingfisher

public class KfWebPOptions {

    public static func webp() -> KingfisherOptionsInfoItem {

        let processor = WebPProcessor.default
        return KingfisherOptionsInfoItem.processor(processor)
    }

    public static func webpCache() -> KingfisherOptionsInfoItem {

        let serializer = WebPSerializer.default
        return KingfisherOptionsInfoItem.cacheSerializer(serializer)
    }
}
