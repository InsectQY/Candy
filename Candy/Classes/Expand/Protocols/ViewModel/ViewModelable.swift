//
//  ViewModelable.swift
//  GamerSky
//
//  Created by QY on 2018/7/4.
//  Copyright © 2018年 QY. All rights reserved.
//

import Foundation

public protocol ViewModelable {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

public protocol NestedViewModelable {

    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
