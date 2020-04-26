//
//  Notification+Rx.swift
//  Candy
//
//  Created by Insect on 2019/5/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

extension Reactive where Base: NSObject {

    func post(name aName: NSNotification.Name,
              object anObject: Any? = nil) -> Binder<Void> {
        Binder(base) { _, _ in
            NotificationCenter.default
            .post(name: aName,
                  object: anObject)
        }
    }
}
