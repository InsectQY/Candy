//
//  ViewModelObject.swift
//  Candy
//
//  Created by Insect on 2021/2/19.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

private var context: UInt8 = 0

protocol ViewModelObject: AnyObject {
    associatedtype VMType: ViewModel

    var viewModel: VMType { get set }
}

extension ViewModelObject {

    var viewModel: VMType {
        get {

            if let vmObject = objc_getAssociatedObject(self, &context) as? VMType {
                return vmObject
            }

            var vmObject: VMType
            if let classType: VMType.Type = "\(VMType.self)".classType() {
                vmObject = classType.init()
            } else {
                vmObject = VMType()
            }
            objc_setAssociatedObject(self,
                                     &context,
                                     vmObject,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return vmObject
        }

        set {
            objc_setAssociatedObject(self,
                                     &context,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
