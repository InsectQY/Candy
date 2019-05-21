//
//  ViewModelable.swift
//  GamerSky
//
//  Created by QY on 2018/7/4.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation

protocol ViewModelable {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol NestedViewModelable {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

protocol HasViewModel {
    associatedtype VMType: ViewModel
}

//var key = "Key"

extension HasViewModel {

    var viewModel: ViewModel {

        guard
            let classType = "\(VMType.self)".classType(VMType.self)
        else {
            return VMType()
        }
        return classType.init()
    }

//    var associateValue: ViewModel? {
//        get {
//            return objc_getAssociatedObject(self, &key) as? ViewModel
//        }
//
//        set {
//            objc_setAssociatedObject(self,
//                                     &key,
//                                     newValue,
//                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
}
