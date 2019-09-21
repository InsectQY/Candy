//
//  Toast+UIView.swift
//  Candy
//
//  Created by apple on 2019/5/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import Toast_Swift

public extension UIView {

    func show(_ message: String?,
              duration: TimeInterval = ToastManager.shared.duration,
              position: ToastPosition = ToastManager.shared.position,
              title: String? = nil,
              image: UIImage? = nil,
              style: ToastStyle = ToastManager.shared.style,
              completion: ((_ didTap: Bool) -> Void)? = nil) {

        self.makeToast(message,
                       duration: duration,
                       position: position,
                       title: title,
                       image: image,
                       style: style,
                       completion: completion)
    }
}
