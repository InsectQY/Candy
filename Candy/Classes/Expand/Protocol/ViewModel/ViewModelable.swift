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
