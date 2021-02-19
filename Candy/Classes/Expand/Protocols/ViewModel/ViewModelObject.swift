//
//  ViewModelObject.swift
//  Candy
//
//  Created by Insect on 2021/2/19.
//  Copyright © 2021 Insect. All rights reserved.
//

import Foundation

private var objectContext: UInt8 = 0

protocol ViewModelObject: class {
    associatedtype VMType: ViewModel

    var viewModel: VMType { get set }
}

extension ViewModelObject {

    var viewModel: VMType {
        get {

            if let vmObject = objc_getAssociatedObject(self, &objectContext) as? VMType {
                return vmObject
            }

            var vmObject: VMType
            if let classType: VMType.Type = "\(VMType.self)".classType() {
                vmObject = classType.init()
            } else {
                vmObject = VMType()
            }
            objc_setAssociatedObject(self,
                                     &objectContext,
                                     vmObject,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return vmObject
        }

        set {
            objc_setAssociatedObject(self,
                                     &objectContext,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
